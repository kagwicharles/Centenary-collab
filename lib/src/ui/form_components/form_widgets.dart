import 'dart:collection';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/dynamic.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/user_model.dart';
import 'package:rafiki/src/utils/common_libs.dart';
import 'package:rafiki/src/utils/crypt_lib.dart';
import 'package:rafiki/src/utils/render_utils.dart';
import 'package:vibration/vibration.dart';
import 'dart:io';
import 'package:get/get.dart';

class InputUtil {
  static List<Map<String?, dynamic>> formInputValues = [];
  static Map<String?, dynamic> encryptedField = {};
}

class DropdownButtonWidget extends StatelessWidget {
  final String text;
  String? serviceParamId;
  String? dataSourceId;
  String? controlID;
  ControlID? currentControlID;
  String? merchantID;

  DropdownButtonWidget(
      {Key? key,
      required this.text,
      this.serviceParamId,
      this.dataSourceId,
      this.controlID,
      this.merchantID = ""})
      : super(key: key);

  final _userCodeRepository = UserCodeRepository();
  final _bankAccountRepository = BankAccountRepository();
  final _beneficiaryRepository = BeneficiaryRepository();

  List<UserCode>? _userCodes;
  List<BankAccount>? _bankAccounts;
  List<Beneficiary>? _beneficiaries;
  List<dynamic>? _dropdownItems;
  var _dropdownPicks;
  Map<String, dynamic>? _items;
  String? _currentValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
        future: getDropDownItems(context: context),
        builder:
            (BuildContext context, AsyncSnapshot<List<dynamic>?> snapshot) {
          Widget child = DropdownButtonFormField2(
            value: _currentValue,
            hint: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExpanded: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            items: const [],
          );
          if (snapshot.hasData) {
            _dropdownItems = snapshot.data;
            if (currentControlID == ControlID.BANKACCOUNTID) {
              _bankAccounts =
                  List<BankAccount>.from(_dropdownItems!).toSet().toList();
              _items = _bankAccounts?.fold<Map<String, dynamic>>(
                  {},
                  (acc, curr) => acc
                    ..[curr.bankAccountId] = curr.aliasName.isEmpty
                        ? curr.bankAccountId
                        : curr.aliasName);
            } else if (currentControlID == ControlID.BENEFICIARYACCOUNTID) {
              _beneficiaries =
                  List<Beneficiary>.from(_dropdownItems!).toSet().toList();
              _items = _beneficiaries?.fold<Map<String, dynamic>>({},
                  (acc, curr) => acc..[curr.merchantID] = curr.merchantName);
            } else {
              _userCodes = List<UserCode>.from(_dropdownItems!);
              _items = _userCodes?.fold<Map<String, dynamic>>(
                  {}, (acc, curr) => acc..[curr.subCodeId] = curr.description!);
            }

            _dropdownPicks = _items?.entries
                .map((userCode) => DropdownMenuItem(
                      value: userCode.key,
                      child: Text(
                        userCode.value,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ))
                .toList();
            debugPrint("Dropdown items...${_dropdownPicks?.toList()}");
            _dropdownPicks?.toSet().toList();
            if (_dropdownPicks != null) {
              if (_dropdownPicks!.isNotEmpty) {
                _currentValue = _dropdownPicks![0].value;
              }
            }

            child = DropdownButtonFormField2(
              value: _currentValue,
              hint: Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              onChanged: ((value) => {_currentValue = value.toString()}),
              validator: (value) {
                debugPrint("Dropdown value...$value");
                InputUtil.formInputValues.add({"$serviceParamId": "$value"});
              },
              items: _dropdownPicks,
            );
          }
          return child;
        });
  }

  getDropDownItems({required context}) {
    debugPrint("Control ID...$controlID");
    var controlIDType;
    try {
      controlIDType = ControlID.values.byName(controlID!);
    } catch (e) {
      debugPrint(e.toString());
    }

    switch (controlIDType) {
      case ControlID.BANKACCOUNTID:
        {
          currentControlID = controlIDType;
          return _bankAccountRepository.getAllBankAccounts();
        }
      case ControlID.BENEFICIARYACCOUNTID:
        {
          currentControlID = controlIDType;
          print("Merchant id...$merchantID");
          merchantID ??= "";
          return _beneficiaryRepository.getAllBeneficiaries(merchantID!);
        }
      default:
        {
          currentControlID = ControlID.OTHER;
          return _userCodeRepository.getUserCodesById(dataSourceId);
        }
    }
  }
}

class TextInputWidget extends StatefulWidget {
  final String text;
  String? controlFormat;
  String? serviceParamId;
  String? controlValue;
  String? minValue;
  String? maxValue;
  bool isMandatory;
  bool isObscured;

  TextInputWidget({
    Key? key,
    required this.text,
    this.controlFormat,
    this.serviceParamId,
    this.controlValue,
    this.minValue,
    this.maxValue,
    this.isMandatory = false,
    this.isObscured = false,
  }) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();
  var inputType = TextInputType.text;
  var suffixIcon;

  @override
  Widget build(BuildContext context) {
    var textFieldParams = RenderUtils.checkControlFormat(widget.controlFormat!,
        context: context,
        isObscure: widget.isObscured,
        refreshParent: refreshParent);

    return TextFormField(
        controller: controller,
        keyboardType: textFieldParams['inputType'],
        obscureText: widget.isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.text,
          suffixIcon: textFieldParams['suffixIcon'],
        ),
        style: const TextStyle(fontSize: 16),
        validator: (value) {
          if (widget.isMandatory && value!.isEmpty) {
            return 'Input required*';
          }
          // if (widget.maxValue != null) {
          //   if (int.parse(value!) > int.parse(widget.maxValue!)) {
          //     return "Input exceeds max value!";
          //   }
          // }
          // if (widget.minValue != null) {
          //   if (int.parse(value!) < int.parse(widget.minValue!)) {
          //     return "Input less min value!";
          //   }
          // }
          if (widget.isObscured) {
            InputUtil.encryptedField[widget.serviceParamId] =
                CryptLibImpl.encryptField(value!);
          } else {
            InputUtil.formInputValues
                .add({"${widget.serviceParamId}": "$value"});
          }
          return null;
        });
  }

  void refreshParent(bool status, {newText}) {
    print("refresh called!");
    setState(() {
      status;
      controller.text = DateFormat('yyyy-MM-dd').format(newText);
    });
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  var formKey;
  String moduleId;
  String actionId;
  String? merchantID;
  String? moduleName;
  final _dynamicRequest = DynamicRequest();

  ButtonWidget(
      {Key? key,
      required this.text,
      this.formKey,
      required this.moduleId,
      required this.actionId,
      this.merchantID,
      this.moduleName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ElevatedButton(
          onPressed: () {
            // InputUtil.formInputValues.clear();
            if (formKey.currentState.validate()) {
              EasyLoading.show(status: 'Processing...');
              InputUtil.formInputValues.add({"MerchantID": "$merchantID"});
              debugPrint(InputUtil.formInputValues.toString());
              debugPrint("Pre-dynamic call Module Name...$moduleName");
              _dynamicRequest.dynamicRequest(moduleId, actionId,
                  merchantID: merchantID,
                  moduleName: moduleName,
                  dataObj: InputUtil.formInputValues,
                  encryptedField: InputUtil.encryptedField,
                  context: context);
            } else {
              Vibration.vibrate();
            }
          },
          child: Text(text),
        ));
  }
}

class RButtonWidget extends StatelessWidget {
  final String text;

  RButtonWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}

class LabelWidget extends StatelessWidget {
  final String text;

  LabelWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class QRCodeScanner extends StatefulWidget {
  QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();

  Uint8List bytes = Uint8List(0);
}

class _QRCodeScannerState extends State<QRCodeScanner>
    with WidgetsBindingObserver {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  bool hasScanned = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        rebuildWidget();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    var paddingTop = Get.statusBarHeight;
    var totalHeight = MediaQuery.of(context).size.height;
    debugPrint("Status bar height...$paddingTop...Total height...$totalHeight");
    var containerHeight = totalHeight - paddingTop;
    print("Container height...$containerHeight");

    return Container(
        height: containerHeight,
        width: MediaQuery.of(context).size.width,
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: hasScanned ? Colors.blue : Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ));
  }

  // return TextButton(onPressed: (){_scanPhoto();}, child: Text("Scan QR"));

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        Vibration.vibrate();
        var code = result?.code;
        debugPrint("Scan result...$code");
        hasScanned = true;
        controller.pauseCamera();
        try {
          Future.delayed(const Duration(milliseconds: 1000), () {
            CommonLibs.openUrl(Uri.parse(code!));
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void rebuildWidget() async {
    // if (mounted) {
    setState(() {
      hasScanned = false;
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
//
// Future _scanPhoto() async {
//   // await Permission.storage.request();
//   String? barcode = await scanner.scan();
//   print("Scanned...$barcode");
// }
}

class PhonePickerFormWidget extends StatefulWidget {
  String? text;
  String? serviceParamId;

  PhonePickerFormWidget({Key? key, required this.text, this.serviceParamId})
      : super(key: key);

  @override
  State<PhonePickerFormWidget> createState() => _PhonePickerFormWidgetState();
}

class _PhonePickerFormWidgetState extends State<PhonePickerFormWidget> {
  String? number;

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Text: text");
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.text,
        suffixIcon: IconButton(
            icon: const Icon(
              Icons.contacts,
              color: Colors.blue,
            ),
            onPressed: () async {
              final PhoneContact contact =
                  await FlutterContactPicker.pickPhoneContact();
              number = contact.phoneNumber?.number;
              controller.text = number!;
            }),
      ),
      validator: (value) {
        InputUtil.formInputValues.add({"${widget.serviceParamId}": "$value"});
      },
      style: const TextStyle(fontSize: 16),
    );
  }
}

class TextViewWidget extends StatelessWidget {
  TextViewWidget({Key? key, this.jsonTxt}) : super(key: key);
  var jsonTxt;
  List<LinkedHashMap> mapItems = [];

  @override
  Widget build(BuildContext context) {
    // return Text(jsonTxt!.toString());
    debugPrint("Textview data...$jsonTxt");
    jsonTxt.forEach((item) {
      debugPrint("Adding...$item");
      mapItems.add(item);
    });
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mapItems.length,
        itemBuilder: (context, index) {
          var mapItem = mapItems[index];
          mapItem.removeWhere((key, value) =>
              key == null || value == null || value.length <= 0);
          debugPrint("New map...$mapItem");

          return Material(
              elevation: 2,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  children: mapItem
                      .map((key, value) => MapEntry(
                          key,
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$key:",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Flexible(
                                      child: Text(
                                    value,
                                    textAlign: TextAlign.right,
                                  ))
                                ],
                              ))))
                      .values
                      .toList(),
                ),
              ));
        },
      ),
      const SizedBox(
        height: 12,
      )
    ]);
  }
}

class ListWidget extends StatelessWidget {
  ListWidget({Key? key, this.dynamicList}) : super(key: key);

  var dynamicList;

  List<Map> mapItems = [];

  @override
  Widget build(BuildContext context) {
    // return Text(jsonTxt!.toString());
    debugPrint("Textview data...$dynamicList");
    dynamicList.forEach((item) {
      debugPrint("Adding...$item");
      mapItems.add(item);
    });
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mapItems.length,
        itemBuilder: (context, index) {
          var mapItem = mapItems[index];
          mapItem.removeWhere((key, value) => key == null || value == null);
          debugPrint("New map...$mapItem");
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Material(
                      elevation: 2,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          children: mapItem
                              .map((key, value) => MapEntry(
                                  key,
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "$key:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Flexible(
                                              child: Text(
                                            value.toString(),
                                            textAlign: TextAlign.right,
                                          ))
                                        ],
                                      ))))
                              .values
                              .toList(),
                        ),
                      )),
                  const SizedBox(
                    height: 12,
                  )
                ],
              ));
        },
      ),
    ]);
  }
}

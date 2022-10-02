import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/dynamic.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/utils/crypt_lib.dart';
import 'package:rafiki/src/utils/determine_render_widget.dart';
import 'package:rafiki/src/utils/render_utils.dart';
import 'package:vibration/vibration.dart';

import 'package:qrscan/qrscan.dart' as scanner;


class InputUtil {
  static List<Map<String?, dynamic>> formInputValues = [];
}

class DropdownButtonWidget extends StatefulWidget {
  final String text;
  String? serviceParamId;
  String? dataSourceId;

  DropdownButtonWidget(
      {Key? key, required this.text, this.serviceParamId, this.dataSourceId})
      : super(key: key);

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  List<String> dropdownItems = [];

  final _userCodeRepository = UserCodeRepository();

  List<UserCode>? _dropDownItems;

  String? _currentValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserCode>?>(
        future: getDropDownItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserCode>?> snapshot) {
          Widget child = DropdownButtonFormField2(
            value: _currentValue,
            hint: Text(
              widget.text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExpanded: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            items: const [],
          );
          if (snapshot.hasData) {
            // _dropDownItems?.clear();
            // print("*After clear>>$_dropDownItems");
            _dropDownItems = snapshot.data;
            // print("*After add..$_dropDownItems");
            // print("Current dropdown value>>>$_currentValue");
            child = DropdownButtonFormField2(
              value: _currentValue,
              hint: Text(
                widget.text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              onChanged: ((value) => {_currentValue = value.toString()}),
              validator: (value) {
                InputUtil.formInputValues
                    .add({widget.serviceParamId: _currentValue});
              },
              items: _dropDownItems?.map((value) {
                print(value.description);
                return DropdownMenuItem(
                  value: value.description,
                  child: Text(
                    value.description!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              }).toList(),
            );
          }
          return child;
        });
  }

  getDropDownItems() {
    if (widget.dataSourceId != null) {
      return _userCodeRepository.getUserCodesById(widget.dataSourceId);
    }
  }
}

class TextInputWidget extends StatefulWidget {
  final String text;
  String? controlFormat;
  String? serviceParamId;
  bool isMandatory;
  bool isObscured;
  var controller;

  TextInputWidget(
      {Key? key,
      required this.text,
      this.controlFormat,
      this.serviceParamId,
      this.isMandatory = false,
      this.controller,
      this.isObscured = false})
      : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  var inputType = TextInputType.text;
  var suffixIcon;

  @override
  Widget build(BuildContext context) {
    print("texfield ${widget.isMandatory}");
    print("Control format ${widget.controlFormat}");
    var texfieldParams = RenderUtils.checkControlFormat(widget.controlFormat!,
        context: context,
        isObscure: widget.isObscured,
        refreshParent: refreshParent);

    return TextFormField(
        controller: widget.controller,
        keyboardType: texfieldParams['inputType'],
        obscureText: widget.isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.text,
          suffixIcon: texfieldParams['suffixIcon'],
        ),
        style: const TextStyle(fontSize: 16),
        validator: (value) {
          if (widget.isMandatory && value!.isEmpty) {
            return 'Input required*';
          }
          InputUtil.formInputValues.add({
            widget.serviceParamId:
                widget.isObscured ? CryptLibImpl.encryptField(value!) : value
          });
          print("validator running...");
          return null;
        });
  }

  void refreshParent(bool status) {
    print("refresh called!");
    setState(() {
      status;
    });
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  var formKey;
  String moduleId;
  String actionId;
  final _dynamicRequest = DynamicRequest();

  ButtonWidget({
    Key? key,
    required this.text,
    this.formKey,
    required this.moduleId,
    required this.actionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        InputUtil.formInputValues.clear();
        if (formKey.currentState.validate()) {
          print("Form is okay...");
          print(InputUtil.formInputValues.toString());
          _dynamicRequest.dynamicRequest(moduleId, actionId,
              dataObj: InputUtil.formInputValues);
        } else {
          Vibration.vibrate();
        }
      },
      child: Text(text),
    );
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
  // MobileScannerController cameraController = MobileScannerController();

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();

  Uint8List bytes = Uint8List(0);
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){_scanPhoto();}, child: Text("Scan QR"));
  }

  Future _scanPhoto() async {
    // await Permission.storage.request();
    String? barcode = await scanner.scan();
    print("Scanned...$barcode");
  }
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
        InputUtil.formInputValues.add({widget.serviceParamId: value!});
      },
      style: const TextStyle(fontSize: 16),
    );
  }
}

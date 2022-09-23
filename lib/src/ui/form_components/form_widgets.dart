import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/utils/crypt_lib.dart';
import 'package:rafiki/src/utils/determine_render_widget.dart';
import 'package:vibration/vibration.dart';

class InputUtil {
  static List<Map<String?, dynamic>> formInputValues = [];
}

class DropdownButtonWidget extends StatefulWidget {
  final String text;
  String? serviceParamId;
  List<String> dropdownItems = [];

  DropdownButtonWidget({Key? key, required this.text, this.serviceParamId})
      : super(key: key);

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  @override
  Widget build(BuildContext context) {
    var currentValue =
        widget.dropdownItems.isNotEmpty ? widget.dropdownItems[0] : null;

    return DropdownButtonFormField2(
      value: currentValue,
      hint: Text(
        widget.text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      isExpanded: true,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      onChanged: (value) {
        setState(() {
          // InputUtil.formInputValues.add(value.toString());
        });
      },
      validator: (value) {
        InputUtil.formInputValues.add({widget.serviceParamId: value});
      },
      items: widget.dropdownItems.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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
  @override
  Widget build(BuildContext context) {
    print("texfield ${widget.isMandatory}");
    print("Control format ${widget.controlFormat}");
    var isPinType = widget.controlFormat == ControlFormat.PinNumber.name ||
            widget.controlFormat == ControlFormat.PIN.name
        ? true
        : false;

    return TextFormField(
        controller: widget.controller,
        keyboardType: widget.controlFormat == ControlFormat.NUMERIC.name ||
                widget.controlFormat == ControlFormat.Amount.name
            ? TextInputType.number
            : TextInputType.text,
        obscureText: widget.isObscured,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.text,
          suffixIcon: widget.controlFormat == ControlFormat.PinNumber.name ||
                  widget.controlFormat == ControlFormat.PIN.name
              ? IconButton(
                  onPressed: () {
                    if (widget.isObscured) {
                      setState(() {
                        widget.isObscured = false;
                      });
                    } else {
                      setState(() {
                        widget.isObscured = true;
                      });
                    }
                  },
                  icon: Icon(widget.isObscured
                      ? Icons.visibility
                      : Icons.visibility_off))
              : null,
        ),
        style: const TextStyle(fontSize: 16),
        validator: (value) {
          InputUtil.formInputValues.add({
            widget.serviceParamId:
                isPinType ? CryptLibImpl.encryptField(value!) : value!
          });
          if (value.isEmpty && widget.isMandatory) {
            return 'Input required*';
          }
          return null;
        });
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  var formKey;

  ButtonWidget({Key? key, required this.text, this.formKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        InputUtil.formInputValues.clear();
        if (formKey.currentState.validate()) {
          print("Form is okay...");
          print(InputUtil.formInputValues.toString());
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

class QRScannerFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      "assets/images/qr-code.png",
      height: 54,
      width: 54,
    ));
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

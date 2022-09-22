import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/utils/utils.dart';
import 'package:vibration/vibration.dart';

class DropdownButtonWidget extends StatefulWidget {
  final String text;
  String? controller;
  List<String> dropdownItems = [];

  DropdownButtonWidget({
    Key? key,
    required this.text,
    required this.controller,
  }) : super(key: key);

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
        setState(() {});
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
  bool isMandatory = false;
  var controller;

  TextInputWidget(
      {Key? key, required this.text, this.isMandatory = false, this.controller})
      : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    print("texfield ${widget.isMandatory}");
    return TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.text,
        ),
        style: const TextStyle(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty && widget.isMandatory) {
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
        CommonUtils.textfieldValues.clear();

        if (formKey.currentState.validate()) {
          print("Form is okay...");
          print(CommonUtils.textfieldValues.toString());
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

class PhonePickerFormWidget extends StatelessWidget {
  final String text;

  final _phoneInputController = TextEditingController();
  String? number;

  PhonePickerFormWidget({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _phoneInputController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: text,
        suffixIcon: IconButton(
            icon: const Icon(
              Icons.contacts,
              color: Colors.blue,
            ),
            onPressed: () async {
              final PhoneContact contact =
                  await FlutterContactPicker.pickPhoneContact();
              number = contact.phoneNumber?.number;
              _phoneInputController.text = number!;
            }),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/utils/determine_render_widget.dart';
import 'package:vibration/vibration.dart';

class DropdownButtonWidget extends StatefulWidget {
  final String text;
  String? controller;
  List<String> dropdownItems = [];

  DropdownButtonWidget({Key? key, required this.text, required this.controller})
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
  String? controlFormat;
  bool isMandatory;
  bool obscureText;
  var controller;

  TextInputWidget(
      {Key? key,
      required this.text,
      this.controlFormat,
      this.isMandatory = false,
      this.obscureText = false,
      this.controller})
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
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.text,
          suffixIcon: widget.controlFormat == ControlFormat.PinNumber.name
              ? IconButton(
                  onPressed: () {
                    if (widget.obscureText) {
                      setState(() {
                        widget.obscureText = false;
                      });
                    } else {
                      setState(() {
                        widget.obscureText = true;
                      });
                    }
                  },
                  icon: Icon(widget.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off))
              : null,
        ),
        style: const TextStyle(fontSize: 16),
        validator: (value) {
          DetermineRenderWidget.textfieldValues.add(value!);
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
        // CommonUtils.textfieldValues.clear();

        if (formKey.currentState.validate()) {
          print("Form is okay...");
          // print(CommonUtils.textfieldValues.toString());
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

  PhonePickerFormWidget({Key? key, required this.text}) : super(key: key);

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
        DetermineRenderWidget.textfieldValues.add(value!);
      },
      style: const TextStyle(fontSize: 16),
    );
  }
}

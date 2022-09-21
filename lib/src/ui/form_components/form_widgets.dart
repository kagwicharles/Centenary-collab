import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/utils/utils.dart';
import 'package:vibration/vibration.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String text;
  String? selectedItem;

  DropdownButtonWidget({
    Key? key,
    required this.text,
    required this.selectedItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: selectedItem,
      isExpanded: true,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      onChanged: (value) {},
      items: [
        DropdownMenuItem<String>(
          child: Text(text),
        )
      ],
    );
  }
}

class TextInputWidget extends StatelessWidget {
  final String text;
  bool isMandatory = false;
  var inputController = TextEditingController();

  TextInputWidget({Key? key, required this.text, isMandatory})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: inputController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: text,
        ),
        style: const TextStyle(fontSize: 16),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required*';
          } else {
            print("field has been validated");
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
        if (formKey.currentState.validate()) {
          print("Form is okay...");
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

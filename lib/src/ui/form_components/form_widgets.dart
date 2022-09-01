import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:lottie/lottie.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String text;
  String? selectedItem;

  DropdownButtonWidget(
      {Key? key, required this.text, required this.selectedItem})
      : super(key: key);
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

  TextInputWidget({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: text,
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;

  ButtonWidget({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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

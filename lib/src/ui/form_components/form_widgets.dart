import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

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

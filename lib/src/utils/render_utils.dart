import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';

class RenderUtils {
  static Map<String, dynamic> checkControlFormat(String widgetControlFormat,
      {context, isObscure, refreshParent}) {
    var inputType = TextInputType.text;
    var suffixIcon;
    var controlFormat;
    try {
      controlFormat = ControlFormat.values.byName(widgetControlFormat);
    } catch (e) {}
    switch (controlFormat) {
      case ControlFormat.DATE:
        {
          inputType = TextInputType.datetime;
          suffixIcon = IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: const Icon(Icons.calendar_month));
        }
        break;
      case ControlFormat.NUMERIC:
        {
          inputType = TextInputType.number;
        }
        break;
      case ControlFormat.Amount:
        {
          inputType = TextInputType.number;
        }
        break;
      case ControlFormat.PinNumber:
        inputType = TextInputType.text;
        // suffixIcon = IconButton(
        //     onPressed: () {
        //       if (isObscure) {
        //         refreshParent(false);
        //       } else {
        //         refreshParent(true);
        //       }
        //     },
        //     icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off));
        break;
      case ControlFormat.PIN:
        inputType = TextInputType.text;
        break;
    }
    Map<String, dynamic> textFieldParams = {
      "inputType": inputType,
      "suffixIcon": suffixIcon
    };
    return textFieldParams;
  }

  static Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:vibration/vibration.dart';

class CommonUtils {
  static List<String> textfieldValues = [];
  static List<String> dropdownItems = [];

  static Widget determineRenderWidget(
    ViewType widgetType, {
    text,
    imageUrl,
    isMandatory,
    formWidgets,
    formKey,
    dropdownController,
    textfieldController,
    textFieldsValue,
  }) {
    String? selectedItem;
    Widget dynamicWidgetItem;

    switch (widgetType) {
      case ViewType.TEXT:
        {
          dynamicWidgetItem = TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: text,
              ),
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                textfieldValues.add(value!);
                if (value == null || value.isEmpty && isMandatory) {
                  return 'Input required*';
                }
                return null;
              });
        }
        break;
      case ViewType.BUTTON:
        {
          dynamicWidgetItem = ButtonWidget(text: text, formKey: formKey);
        }
        break;
      case ViewType.DROPDOWN:
        {
          var currentValue = dropdownItems.isNotEmpty ? dropdownItems[0] : null;
          dynamicWidgetItem = DropdownButtonFormField2(
            value: currentValue,
            hint: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExpanded: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            onChanged: (value) {},
            items: dropdownItems.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        }
        break;
      // case ViewType.RBUTTON:
      //   {
      //     return RButtonWidget(text: text);
      //   }
      case ViewType.LABEL:
        {
          dynamicWidgetItem = LabelWidget(text: text);
        }
        break;

      case ViewType.QRSCANNER:
        {
          dynamicWidgetItem = QRScannerFormWidget();
        }
        break;

      case ViewType.PHONECONTACTS:
        {
          String? number;
          var controller = TextEditingController();
          dynamicWidgetItem = TextFormField(
            controller: controller,
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
                    controller.text = number!;
                  }),
            ),
            onChanged: ((value) => {controller.text = value}),
            style: const TextStyle(fontSize: 16),
          );
        }
        break;
      default:
        {
          return const Visibility(
            visible: false,
            child: SizedBox(),
          );
        }
    }

    return Column(
      children: [
        dynamicWidgetItem,
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  validateFormFields(List<TextFormField> inputFields) {
    inputFields.forEach((field) {
      if (field.controller?.text == null || field.controller!.text.isEmpty) {
        Vibration.vibrate();
      }
    });
  }
}

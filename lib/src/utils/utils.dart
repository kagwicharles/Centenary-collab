import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:vibration/vibration.dart';

class CommonUtils {
  static Widget determineRenderWidget(ViewType widgetType,
      {text, imageUrl, isMandatory, formWidgets, formKey}) {
    String? selectedItem;
    Widget dynamicWidgetItem;

    switch (widgetType) {
      case ViewType.TEXT:
        {
          dynamicWidgetItem =
              TextInputWidget(text: text, isMandatory: isMandatory);
        }
        break;
      case ViewType.BUTTON:
        {
          dynamicWidgetItem = ButtonWidget(text: text, formKey: formKey);
        }
        break;
      case ViewType.DROPDOWN:
        {
          dynamicWidgetItem =
              DropdownButtonWidget(text: text, selectedItem: selectedItem);
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
          dynamicWidgetItem = PhonePickerFormWidget(
            text: text,
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

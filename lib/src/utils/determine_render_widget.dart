import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:vibration/vibration.dart';

class DetermineRenderWidget extends StatelessWidget {
  static List<String> textfieldValues = [];
  static List<String> dropdownItems = [];
  ViewType? widgetType;
  String? controlFormat;
  bool isMandatory;
  String text;
  String imageUrl;
  String? serviceParamId;
  String? moduleId;
  String? actionId;
  FormItem formItem;
  var formKey;

  DetermineRenderWidget(this.widgetType,
      {this.text = "",
      this.imageUrl = "",
      this.isMandatory = false,
      formWidgets,
      this.controlFormat,
      this.serviceParamId,
      this.formKey,
      this.moduleId,
      this.actionId,
      required this.formItem,
      refreshParent});

  Function()? refreshParent;

  String? selectedItem;

  bool obscureText = false;

  String? number = "";

  Widget? dynamicWidgetItem;

  @override
  Widget build(BuildContext context) {
    print("Widget type: $widgetType");
    switch (widgetType) {
      case ViewType.TEXT:
        {
          print(controlFormat);
          obscureText = controlFormat == ControlFormat.PinNumber.name ||
                  controlFormat == ControlFormat.PIN.name
              ? true
              : false;
          dynamicWidgetItem = TextInputWidget(
              text: text,
              isMandatory: isMandatory,
              controlFormat: controlFormat,
              serviceParamId: serviceParamId,
              isObscured: obscureText);
        }
        break;

      case ViewType.DATE:
        {
          print(controlFormat);

          dynamicWidgetItem = TextInputWidget(
            text: text,
            isMandatory: isMandatory,
            controlFormat: controlFormat,
            serviceParamId: serviceParamId,
          );
        }
        break;

      case ViewType.BUTTON:
        {
          dynamicWidgetItem = ButtonWidget(
            text: formItem.controlText!,
            formKey: formKey,
            moduleId: formItem.moduleId!,
            actionId: formItem.actionId!,
          );
        }
        break;

      case ViewType.DROPDOWN:
        {
          dynamicWidgetItem = DropdownButtonWidget(
            text: text,
            serviceParamId: serviceParamId,
            dataSourceId: formItem.dataSourceId,
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
          dynamicWidgetItem = PhonePickerFormWidget(
            text: text,
            serviceParamId: serviceParamId,
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
        dynamicWidgetItem!,
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

import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:vibration/vibration.dart';

class DetermineRenderWidget extends StatelessWidget {
  static List<String> textfieldValues = [];
  static List<String> dropdownItems = [];
  ViewType? widgetType;
  String? merchantID, moduleName;
  FormItem formItem;
  var jsonTxt;
  var formKey;

  DetermineRenderWidget(this.widgetType,
      {Key? key,
      formWidgets,
      this.formKey,
      this.merchantID,
      this.moduleName,
      required this.formItem,
      this.jsonTxt,
      refreshParent})
      : super(key: key);

  Function()? refreshParent;

  String? selectedItem;

  bool obscureText = false;

  String? number = "";

  Widget? dynamicWidgetItem;

  @override
  Widget build(BuildContext context) {
    switch (widgetType) {
      case ViewType.TEXT:
        {
          obscureText =
              formItem.controlFormat == ControlFormat.PinNumber.name ||
                      formItem.controlFormat == ControlFormat.PIN.name
                  ? true
                  : false;
          dynamicWidgetItem = TextInputWidget(
              text: formItem.controlText!,
              isMandatory: formItem.isMandatory!,
              controlFormat: formItem.controlFormat,
              serviceParamId: formItem.serviceParamId,
              isObscured: obscureText);
        }
        break;

      case ViewType.DATE:
        {
          dynamicWidgetItem = TextInputWidget(
            text: formItem.controlText!,
            isMandatory: formItem.isMandatory!,
            controlFormat: formItem.controlFormat,
            serviceParamId: formItem.serviceParamId,
          );
        }
        break;

      case ViewType.HIDDEN:
        {
          InputUtil.formInputValues
              .add({"${formItem.serviceParamId}": "${formItem.controlValue}"});
          return const Visibility(
            visible: false,
            child: SizedBox(),
          );
        }

      case ViewType.BUTTON:
        {
          dynamicWidgetItem = ButtonWidget(
            text: formItem.controlText!,
            formKey: formKey,
            moduleId: formItem.moduleId!,
            actionId: formItem.actionId!,
            merchantID: merchantID,
            moduleName: moduleName,
          );
        }
        break;

      case ViewType.DROPDOWN:
        {
          dynamicWidgetItem = DropdownButtonWidget(
            text: formItem.controlText!,
            serviceParamId: formItem.serviceParamId!,
            dataSourceId: formItem.dataSourceId,
            controlID: formItem.controlId,
            merchantID: merchantID,
          );
        }
        break;

      case ViewType.LABEL:
        {
          dynamicWidgetItem = LabelWidget(text: formItem.controlText!);
        }
        break;

      case ViewType.QRSCANNER:
        {
          dynamicWidgetItem = QRCodeScanner();
        }
        break;

      case ViewType.PHONECONTACTS:
        {
          dynamicWidgetItem = PhonePickerFormWidget(
            text: formItem.controlText,
            serviceParamId: formItem.serviceParamId,
          );
        }
        break;

      case ViewType.TEXTVIEW:
        {
          dynamicWidgetItem = jsonTxt != null
              ? TextViewWidget(jsonTxt: jsonTxt!)
              : const Visibility(
                  visible: false,
                  child: SizedBox(),
                );
        }
        break;
      // case ViewType.LIST:
      //   {
      //     InputUtil.formInputValues.add({"HEADER": "${formItem.actionId}"});
      //     _dynamicRequest.dynamicRequest(formItem.moduleId!, formItem.actionId!,
      //         merchantID: merchantID,
      //         moduleName: moduleName,
      //         dataObj: InputUtil.formInputValues,
      //         encryptedField: InputUtil.encryptedField,
      //         context: context);
      //     dynamicWidgetItem = const Visibility(
      //       visible: false,
      //       child: SizedBox(),
      //     );
      //   }
      //   break;
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

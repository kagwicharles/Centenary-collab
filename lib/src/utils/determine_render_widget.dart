import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/dynamic.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/utils/common_libs.dart';
import 'package:vibration/vibration.dart';

class DetermineRenderWidget extends StatelessWidget {
  final _dynamicRequest = DynamicRequest();
  Widget? dynamicWidgetItem;

  Widget getWidget(ViewType widgetType, FormItem formItem,
      {required context,
      required formKey,
      obscureText = false,
      merchantID,
      moduleName,
      controlValue,
      jsonTxt}) {
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
            isObscured: obscureText,
            minValue: formItem.minValue,
            maxValue: formItem.minValue,
          );
        }
        break;

      case ViewType.DATE:
        {
          dynamicWidgetItem = TextInputWidget(
            text: formItem.controlText!,
            isMandatory: formItem.isMandatory!,
            controlFormat: formItem.controlFormat,
            serviceParamId: formItem.serviceParamId,
            minValue: formItem.minValue,
            maxValue: formItem.maxValue,
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
      case ViewType.LIST:
        List<dynamic>? dynamicList;
        {
          if (formItem.controlFormat != null &&
              formItem.controlFormat!.isNotEmpty) {
            dynamicWidgetItem =
                const Visibility(visible: false, child: SizedBox());
          } else {
            EasyLoading.show(status: "Processing");
            await _dynamicRequest
                .dynamicRequest(formItem.moduleId!, formItem.actionId!,
                    merchantID: merchantID,
                    moduleName: moduleName,
                    dataObj: InputUtil.formInputValues,
                    encryptedField: InputUtil.encryptedField,
                    isList: true,
                    context: context)
                .then((value) => {
                      debugPrint("Returning from dynamic call...$value"),
                      dynamicList = value?.dynamicList,
                      dynamicWidgetItem = ListWidget(dynamicList: dynamicList)
                    });
          }
        }
        break;

      case ViewType.HYPERLINK:
        {
          if (controlValue != null) {
            Navigator.pop(context);
            CommonLibs.openUrl(Uri.parse(controlValue!));
          }
          dynamicWidgetItem = const Visibility(
            visible: false,
            child: SizedBox(),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  validateFormFields(List<TextFormField> inputFields) {
    inputFields.forEach((field) {
      if (field.controller?.text == null || field.controller!.text.isEmpty) {
        Vibration.vibrate();
      }
    });
  }
}

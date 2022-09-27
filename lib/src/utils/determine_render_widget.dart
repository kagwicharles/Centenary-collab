import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:vibration/vibration.dart';

class DetermineRenderWidget extends StatefulWidget {
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

  @override
  State<DetermineRenderWidget> createState() => _DetermineRenderWidgetState();
}

class _DetermineRenderWidgetState extends State<DetermineRenderWidget> {
  Function()? refreshParent;

  String? selectedItem;
  bool obscureText = false;
  String? number = "";

  Widget? dynamicWidgetItem;

  @override
  Widget build(BuildContext context) {
    print("Widget type: ${widget.widgetType}");
    switch (widget.widgetType) {
      case ViewType.TEXT:
        {
          print(widget.controlFormat);
          obscureText = widget.controlFormat == ControlFormat.PinNumber.name ||
                  widget.controlFormat == ControlFormat.PIN.name
              ? true
              : false;
          dynamicWidgetItem = TextInputWidget(
              text: widget.text,
              isMandatory: widget.isMandatory,
              controlFormat: widget.controlFormat,
              serviceParamId: widget.serviceParamId,
              isObscured: obscureText);
        }
        break;

      case ViewType.DATE:
        {
          print(widget.controlFormat);

          dynamicWidgetItem = TextInputWidget(
            text: widget.text,
            isMandatory: widget.isMandatory,
            controlFormat: widget.controlFormat,
            serviceParamId: widget.serviceParamId,
          );
        }
        break;

      case ViewType.BUTTON:
        {
          dynamicWidgetItem = ButtonWidget(
            text: widget.formItem.controlText!,
            formKey: widget.formKey,
            moduleId: widget.formItem.moduleId!,
            actionId: widget.formItem.actionId!,
          );
        }
        break;

      case ViewType.DROPDOWN:
        {
          var currentValue = DetermineRenderWidget.dropdownItems.isNotEmpty
              ? DetermineRenderWidget.dropdownItems[0]
              : null;
          dynamicWidgetItem = DropdownButtonWidget(
            text: widget.text,
            serviceParamId: widget.serviceParamId,
          );
        }
        break;

      // case ViewType.RBUTTON:
      //   {
      //     return RButtonWidget(text: text);
      //   }

      case ViewType.LABEL:
        {
          dynamicWidgetItem = LabelWidget(text: widget.text);
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
            text: widget.text,
            serviceParamId: widget.serviceParamId,
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

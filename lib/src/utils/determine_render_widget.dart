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
  var formKey;

  DetermineRenderWidget(this.widgetType,
      {this.text = "",
      this.imageUrl = "",
      this.isMandatory = false,
      formWidgets,
      this.controlFormat,
      this.formKey,
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
          );
        }
        break;
      case ViewType.BUTTON:
        {
          dynamicWidgetItem =
              ButtonWidget(text: widget.text, formKey: widget.formKey);
        }
        break;
      case ViewType.DROPDOWN:
        {
          var currentValue = DetermineRenderWidget.dropdownItems.isNotEmpty
              ? DetermineRenderWidget.dropdownItems[0]
              : null;
          dynamicWidgetItem = DropdownButtonFormField2(
            value: currentValue,
            hint: Text(
              widget.text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            isExpanded: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            onChanged: (value) {
              DetermineRenderWidget.textfieldValues.add(value.toString());
            },
            items: DetermineRenderWidget.dropdownItems.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              DetermineRenderWidget.textfieldValues.add(value.toString());
            },
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
          dynamicWidgetItem = PhonePickerFormWidget(text: widget.text);
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

import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';

class CommonUtils {
  static Widget determineRenderWidget(ViewType widgetType, {text}) {
    String? selectedItem;

    switch (widgetType) {
      case ViewType.TEXT:
        {
          return TextInputWidget(text: text);
        }
      case ViewType.BUTTON:
        {
          return ButtonWidget(text: text);
        }
      case ViewType.DROPDOWN:
        {
          return DropdownButtonWidget(text: text, selectedItem: selectedItem);
        }
      case ViewType.RBUTTON:
        {
          return RButtonWidget(text: text);
        }
      case ViewType.LABEL:
        {
          return LabelWidget(text: text);
        }
      default:
        {
          return Container();
        }
    }
  }
}

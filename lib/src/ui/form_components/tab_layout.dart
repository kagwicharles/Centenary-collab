import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/utils/utils.dart';

class TabWidget extends StatelessWidget {
  List<FormItem> formItems;
  String moduleName;
  List<Tab> tabs = [];
  List<TabWidgetList> tabWidgetList = [];
  List<String> linkControls = [];
  String title;

  TabWidget(
      {required this.title, required this.formItems, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    formItems.forEach((formItem) {
      if (formItem.controlType == ViewType.TAB.name ||
          formItem.controlType == ViewType.RBUTTON.name) {
        linkControls.add(formItem.controlId!);
        tabs.add(Tab(
          text: formItem.controlText!,
        ));
      }
    });

    linkControls.forEach((linkControl) {
      tabWidgetList.add(TabWidgetList(
          formItems: formItems
              .where((formItem) =>
                  formItem.linkedToControl == linkControl ||
                  formItem.linkedToControl == null ||
                  formItem.linkedToControl == "" &&
                      formItem.controlType != ViewType.RBUTTON.name)
              .toList()));
    });
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabs,
              isScrollable: true,
            ),
            title: Text(moduleName),
          ),
          body: TabBarView(children: tabWidgetList),
        ));
  }
}

class TabWidgetList extends StatelessWidget {
  final List<FormItem> formItems;
  final _formKey = GlobalKey<FormState>();

  TabWidgetList({required this.formItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
            key: _formKey,
            child: ListView.builder(
                itemCount: formItems.length,
                itemBuilder: (context, index) {
                  var controlType;
                  try {
                    controlType =
                        ViewType.values.byName(formItems[index].controlType!);
                  } catch (e) {}
                  var controlText = formItems[index].controlText;

                  return Column(children: [
                    CommonUtils.determineRenderWidget(controlType,
                        text: controlText),
                  ]);
                })));
  }
}

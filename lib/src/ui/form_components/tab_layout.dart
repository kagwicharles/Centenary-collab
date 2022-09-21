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

  TabWidget({
    required this.title,
    required this.formItems,
    required this.moduleName,
  });

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

    linkControls.asMap().forEach((index, linkControl) {
      tabWidgetList.add(TabWidgetList(
        formItems: formItems
            .where((formItem) =>
                formItem.linkedToControl == linkControl ||
                formItem.linkedToControl == null ||
                formItem.linkedToControl == "" &&
                    formItem.controlType != ViewType.RBUTTON.name)
            .toList(),
      ));
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

class TabWidgetList extends StatefulWidget {
  final List<FormItem> formItems;
  TabWidgetList({required this.formItems});

  @override
  State<TabWidgetList> createState() => _TabWidgetListState();
}

class _TabWidgetListState extends State<TabWidgetList>
    with AutomaticKeepAliveClientMixin {
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
            key: _formKey,
            child: ListView.builder(
                itemCount: widget.formItems.length,
                itemBuilder: (context, index) {
                  var controlType;
                  try {
                    controlType = ViewType.values
                        .byName(widget.formItems[index].controlType!);
                  } catch (e) {}
                  var controlText = widget.formItems[index].controlText;
                  bool? isMandatory = widget.formItems[index].isMandatory;

                  return CommonUtils.determineRenderWidget(controlType,
                      text: controlText,
                      formKey: _formKey,
                      isMandatory: isMandatory);
                })));
  }

  @override
  bool get wantKeepAlive => true;
}

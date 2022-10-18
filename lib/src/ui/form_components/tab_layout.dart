import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/utils/determine_render_widget.dart';

class TabWidget extends StatelessWidget {
  List<FormItem> formItems;
  String moduleName;
  List<Tab> tabs = [];
  List<TabWidgetList> tabWidgetList = [];
  List<String> linkControls = [];
  String title;
  String? merchantID;
  Function? updateState;

  TabWidget(
      {required this.title,
      required this.formItems,
      required this.moduleName,
      this.merchantID,
      this.updateState});

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
          merchantID: merchantID,
          moduleName: moduleName,
          formItems: formItems
              .where((formItem) =>
                  formItem.linkedToControl == linkControl ||
                  formItem.linkedToControl == null ||
                  formItem.linkedToControl == "" &&
                      formItem.controlType != ViewType.RBUTTON.name)
              .toList()
            ..sort(((a, b) {
              return a.displayOrder!.compareTo(b.displayOrder!);
            })),
          updateState: updateState));
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
  Function? updateState;
  String? merchantID;
  String? moduleName;

  TabWidgetList(
      {required this.formItems,
      this.updateState,
      this.merchantID,
      this.moduleName});

  @override
  State<TabWidgetList> createState() => _TabWidgetListState();
}

class _TabWidgetListState extends State<TabWidgetList> {
  final _formKey = GlobalKey<FormState>();
  final _determineRenderWidget = DetermineRenderWidget();

  @override
  Widget build(BuildContext context) {
    bool containsQR = widget.formItems
        .map((item) => item.controlType)
        .contains(ViewType.QRSCANNER.name);

    return Padding(
        padding: containsQR
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
            key: _formKey,
            child: ListView.builder(
                itemCount: widget.formItems.length,
                itemBuilder: (context, index) {
                  var controlType;
                  String? controlValue = widget.formItems[index].controlValue;
                  try {
                    controlType = ViewType.values
                        .byName(widget.formItems[index].controlType!);
                  } catch (e) {}

                  getWidget() => _determineRenderWidget.getWidget(
                      controlType, widget.formItems[index],
                      context: context,
                      formKey: _formKey,
                      merchantID: widget.merchantID,
                      moduleName: widget.moduleName,
                      controlValue: controlValue);

                  return FutureBuilder<Widget>(
                      future: getWidget(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        Widget child = const SizedBox();
                        if (snapshot.hasData) {
                          child = snapshot.data!;
                        }
                        return child;
                      });
                })));
  }

  @override
  bool get wantKeepAlive => true;
}

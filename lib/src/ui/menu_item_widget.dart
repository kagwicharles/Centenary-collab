import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/dynamic.dart';
import 'package:rafiki/src/ui/dynamic.dart';
import 'package:rafiki/src/utils/common_libs.dart';

import 'form_components/form_widgets.dart';

class ModuleItemWidget extends StatelessWidget {
  final String imageUrl;
  final String moduleName;
  final String moduleId;
  final String parentModule;
  final String moduleCategory;
  String? merchantID;
  bool isMain = false;
  ModuleItem moduleItem;

  final _dynamicRequest = DynamicRequest();

  ModuleItemWidget(
      {Key? key,
      required this.imageUrl,
      required this.moduleName,
      required this.moduleId,
      required this.parentModule,
      required this.moduleCategory,
      this.merchantID,
      this.isMain = false,
      required this.moduleItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: isMain ? Colors.transparent : null,
        child: InkWell(
            onTap: () {
              if (moduleId == "TRANSACTIONSCENTER") {
                getList(context);
              } else {
                CommonLibs.navigateToRoute(
                    context: context,
                    widget: DynamicWidget(
                        moduleId: moduleId,
                        moduleName: moduleName,
                        parentModule: parentModule,
                        moduleCategory: moduleCategory,
                        merchantID: merchantID));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  color: isMain ? Colors.transparent : null,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: isMain == true
                      ? null
                      : Border.all(color: Colors.blueGrey[100]!)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 48,
                      width: 48,
                      placeholder: (context, url) =>
                          Lottie.asset('assets/lottie/loading.json'),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Flexible(
                        child: Text(
                      moduleName,
                      // overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                  ]),
            )));
  }

  getList(context) {
    InputUtil.formInputValues.clear();
    InputUtil.formInputValues.add({"HEADER": "GETTRXLIST"});
    _dynamicRequest.dynamicRequest(moduleItem.moduleId, "GETTRXLIST",
        merchantID: moduleItem.merchantID,
        moduleName: moduleItem.moduleName,
        dataObj: InputUtil.formInputValues,
        encryptedField: InputUtil.encryptedField,
        context: context,
        isNotTransactionList: false);
  }
}

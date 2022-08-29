import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/ui/dynamic.dart';

class ModuleItemWidget extends StatelessWidget {
  final String imageUrl;
  final String moduleName;
  final String moduleId;
  final String parentModule;
  final String moduleCategory;

  ModuleItemWidget(
      {required this.imageUrl,
      required this.moduleName,
      required this.moduleId,
      required this.parentModule,
      required this.moduleCategory});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DynamicWidget(
                        moduleId: moduleId,
                        moduleName: moduleName,
                        parentModule: parentModule,
                        moduleCategory: moduleCategory,
                      )));
            },
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 44,
                      width: 44,
                      placeholder: (context, url) =>
                          Lottie.asset('assets/lottie/loading.json'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Flexible(
                        child: Text(
                      moduleName,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    )),
                  ]),
            )));
  }
}

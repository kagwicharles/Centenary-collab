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
        elevation: 0,
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
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.blueGrey[100]!)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 44,
                      width: 44,
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
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                  ]),
            )));
  }
}

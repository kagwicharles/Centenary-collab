import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/utils/common_libs.dart';

class AdvertsContainer extends StatefulWidget {
  bool? isFirstTimer;

  AdvertsContainer({Key? key, this.isFirstTimer}) : super(key: key);

  @override
  State<AdvertsContainer> createState() => _AdvertsContainerState();

  final _imageDataRepository = ImageDataRepository();
}

class _AdvertsContainerState extends State<AdvertsContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.isFirstTimer != null && widget.isFirstTimer == true) {
      debugPrint("Waiting...");
      Future.delayed(const Duration(seconds: 60), () async {});
    }
    getAdverts().then(
      (value) => {
        print("Adverts $value"),
        if (value.isEmpty) {setState(() {})}
      },
    );
    return Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                    height: 144,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: FutureBuilder<List<ImageData>>(
                        future: getAdverts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ImageData>> snapshot) {
                          Widget child = const SizedBox();
                          if (snapshot.hasData) {
                            var _images = snapshot.data;
                            child = Swiper(
                                controller: SwiperController(),
                                duration: 1000,
                                scrollDirection: Axis.horizontal,
                                autoplay: true,
                                itemCount: _images?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var _image = _images![index].imageUrl;
                                  var _adUrl = _images[index].imageInfoUrl;
                                  return AdvertWidget(
                                    adResource: _image!,
                                    adUrl: _adUrl,
                                  );
                                });
                          }
                          print("No online products yet");
                          return child;
                        })))));
  }

  getAdverts() => widget._imageDataRepository.getAllImages("ADDS");
}

class AdvertWidget extends StatelessWidget {
  AdvertWidget({Key? key, required this.adResource, this.adUrl})
      : super(key: key);

  final String adResource;
  String? adUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        onTap: () {
          CommonLibs.openUrl(Uri.parse(adUrl!));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: adResource,
            // placeholder: (context, url) =>
            //     Lottie.asset('assets/lottie/loading.json'),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ));
  }
}

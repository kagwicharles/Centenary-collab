import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';

class AdvertsContainer extends StatefulWidget {
  @override
  State<AdvertsContainer> createState() => _AdvertsContainerState();

  final _imageDataRepository = ImageDataRepository();
}

class _AdvertsContainerState extends State<AdvertsContainer> {
  @override
  Widget build(BuildContext context) {
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
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                    height: 150,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: FutureBuilder<List<ImageData>>(
                        future: getAdverts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ImageData>> snapshot) {
                          Widget child = const SizedBox();
                          if (snapshot.hasData) {
                            var _images = snapshot.data;

                            child = Swiper(
                                autoplay: true,
                                itemCount: _images?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var _Image = _images![index].imageUrl;
                                  return AdvertWidget(adResource: _Image!);
                                });
                          }
                          print("No online products yet");
                          return child;
                        })))));
  }

  getAdverts() => widget._imageDataRepository.getAllImages("ADDS");
}

class AdvertWidget extends StatelessWidget {
  const AdvertWidget({Key? key, required this.adResource}) : super(key: key);

  final String adResource;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: CachedNetworkImage(
        imageUrl: adResource,
        // placeholder: (context, url) =>
        //     Lottie.asset('assets/lottie/loading.json'),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

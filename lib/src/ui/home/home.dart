import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/home/adverts.dart';
import 'package:rafiki/src/ui/home/credit_card.dart';
import 'package:rafiki/src/ui/home/home_menu_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final String user = "Kagwi";
  final String lastLogin = "Jul 12 2022 11:50AM";

  final List<Widget> creditCards = const [
    CreditCardWidget(),
    CreditCardWidget(),
    CreditCardWidget(),
  ];

  final List<Widget> adverts = const [
    AdvertWidget(
      adResource: "assets/ads/doge-1.jpg",
    ),
    AdvertWidget(adResource: "assets/ads/doge.jpeg"),
    AdvertWidget(adResource: "assets/ads/doge-1.jpg"),
    AdvertWidget(adResource: "assets/ads/doge.jpeg"),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            CircleAvatar(
              child: Image.asset("assets/images/user.png"),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello ${widget.user}"),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Last Login ${widget.lastLogin}",
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            ),
            const Spacer(),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        )),
        body: ListView(
          children: [
            const SizedBox(
              height: 24,
            ),
            Center(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 200,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Swiper(
                        autoplay: true,
                        itemCount: widget.creditCards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return widget.creditCards[index];
                        }))),
            const SizedBox(
              height: 24,
            ),
            Stack(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          )),
                      height: 200,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: MainMenuWidget()),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(18, 124, 18, 10),
                    child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SubMenuWidget(),
                        )))
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 150,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Swiper(
                        autoplay: true,
                        itemCount: widget.adverts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return widget.adverts[index];
                        }))),
            const SizedBox(
              height: 24,
            ),
          ],
        ));
  }
}

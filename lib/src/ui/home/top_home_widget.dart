import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rafiki/src/ui/home/credit_card.dart';

class TopHomeWidget extends StatefulWidget {
  @override
  State<TopHomeWidget> createState() => _TopHomeWidgetState();
}

class _TopHomeWidgetState extends State<TopHomeWidget> {
  final List<Widget> creditCards = const [
    CreditCardWidget(),
    CreditCardWidget(),
    CreditCardWidget(),
  ];
  bool viewCreditCardState = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: viewCreditCardState
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0))),
                      child: IconButton(
                        onPressed: (() {
                          setState(() {
                            viewCreditCardState = true;
                          });
                        }),
                        icon: Icon(
                          Icons.filter_none,
                          size: 40,
                          color:
                              viewCreditCardState ? Colors.white : Colors.black,
                        ),
                      )),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: viewCreditCardState
                              ? Colors.transparent
                              : Colors.blue,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0))),
                      child: IconButton(
                        onPressed: (() {
                          setState(() {
                            viewCreditCardState = false;
                          });
                        }),
                        icon: Icon(
                          Icons.alarm,
                          size: 40,
                          color:
                              viewCreditCardState ? Colors.black : Colors.white,
                        ),
                      ))
                ],
              ),
              viewCreditCardState
                  ? Container(
                      height: 177,
                      constraints: const BoxConstraints(maxWidth: 270),
                      child: Swiper(
                          scrollDirection: Axis.horizontal,
                          autoplay: true,
                          autoplayDelay: 5000,
                          itemCount: creditCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return creditCards[index];
                          }))
                  : Container(
                      height: 177,
                      constraints: const BoxConstraints(maxWidth: 270),
                      child: const Center(
                        child: Text("No alerts yet"),
                      ))
            ]));
  }
}

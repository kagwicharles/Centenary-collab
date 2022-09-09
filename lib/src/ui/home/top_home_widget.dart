import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rafiki/src/ui/home/credit_card.dart';

class TopHomeWidget extends StatefulWidget {
  @override
  State<TopHomeWidget> createState() => _TopHomeWidgetState();
}

class _TopHomeWidgetState extends State<TopHomeWidget> {
  final List<Widget> creditCards = [
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
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: (() => {
                            setState(() {
                              viewCreditCardState = true;
                            })
                          }),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: viewCreditCardState
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Icon(
                            Icons.filter_none,
                            size: 40,
                            color: viewCreditCardState
                                ? Colors.white
                                : Colors.blue,
                          ))),
                  const SizedBox(height: 12),
                  InkWell(
                      onTap: () {
                        setState(() {
                          viewCreditCardState = false;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: viewCreditCardState
                                  ? Colors.white
                                  : Colors.blue,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Icon(
                            Icons.notifications,
                            size: 40,
                            color: viewCreditCardState
                                ? Colors.blue
                                : Colors.white,
                          )))
                ],
              )),
              SizedBox(
                height: 4,
              ),
              viewCreditCardState
                  ? Container(
                      height: 177,
                      constraints: const BoxConstraints(maxWidth: 270),
                      child: Swiper(
                          scrollDirection: Axis.horizontal,
                          autoplay: false,
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

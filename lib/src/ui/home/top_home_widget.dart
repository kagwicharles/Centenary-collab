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
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RotatedBox(
                                    quarterTurns: -1,
                                    child: Text("Cards",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: viewCreditCardState
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ))),
                                Icon(
                                  Icons.radio_button_checked,
                                  size: 12,
                                  color: viewCreditCardState
                                      ? Colors.blue
                                      : Colors.transparent,
                                )
                              ]))),
                  const SizedBox(height: 12),
                  InkWell(
                      onTap: () {
                        setState(() {
                          viewCreditCardState = false;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RotatedBox(
                                  quarterTurns: -1,
                                  child: Text("Alerts",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: viewCreditCardState
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ))),
                              Icon(
                                Icons.radio_button_checked,
                                size: 12,
                                color: viewCreditCardState
                                    ? Colors.transparent
                                    : Colors.blue,
                              )
                            ],
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

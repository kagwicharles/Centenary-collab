import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 175,
            width: 275,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 8,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Image.asset(
                  "assets/icons/visa.png",
                  height: 45,
                  width: 45,
                )
              ]),
              const SizedBox(
                height: 8,
              ),
              const TextAmount(amount: "\$100,000"),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Text(
                    "Show balance",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.visibility,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              const TextLarge(text: "4055 8923 9321 1213"),
            ])));
  }
}

class TextAmount extends StatelessWidget {
  const TextAmount({Key? key, required this.amount}) : super(key: key);
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(amount,
        style: const TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold));
  }
}

class TextLarge extends StatelessWidget {
  const TextLarge({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 14, color: Colors.white));
  }
}

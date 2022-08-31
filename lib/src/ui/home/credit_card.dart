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
                height: 24,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const TextLarge(text: "Total Amount"),
                Image.asset(
                  "assets/icons/visa.png",
                  height: 45,
                  width: 45,
                )
              ]),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                    TextAmount(amount: "\$100,000"),
                    SizedBox(
                      height: 24,
                    ),
                    TextLarge(text: "4055 8923 9321 1213"),
                    SizedBox(
                      height: 8,
                    )
                  ]))
            ])));
  }
}

class TextAmount extends StatelessWidget {
  const TextAmount({Key? key, required this.amount}) : super(key: key);
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(amount,
        style: const TextStyle(fontSize: 14, color: Colors.white));
  }
}

class TextLarge extends StatelessWidget {
  const TextLarge({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 18, color: Colors.white));
  }
}

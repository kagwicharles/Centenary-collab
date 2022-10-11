import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return Text("Transactopn list");
    //   FutureBuilder<String>(
    //     future: _calculation, // a previously-obtained Future<String> or null
    //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //   ListView.builder(
    //   itemCount: items.length,
    //   prototypeItem: ListTile(
    //     title: Text(items.first),
    //   ),
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(items[index]),
    //     );
    //   },
    // );});
  }
}

class Transaction {
  String bankAccountID;
  String status;
  String serviceName;
  String date;

  Transaction(
      {required this.bankAccountID,
      required this.status,
      required this.serviceName,
      required this.date});

  Transaction.fromJson(Map<String, dynamic> json)
      : bankAccountID = json["BankAccountID"],
        status = json["Status"],
        serviceName = json["ServiceName"],
        date = json["Date"];
}

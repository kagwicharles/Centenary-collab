import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  TransactionList(
      {Key? key, required this.dynamicList, required this.moduleName})
      : super(key: key);
  var dynamicList;
  String moduleName;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Transaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    addTransactions(list: widget.dynamicList);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Transactions...$transactionList");
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.moduleName),
        ),
        body: ListView.builder(
          itemCount: transactionList.length,
          itemBuilder: (context, index) {
            return TransactionItem(transaction: transactionList[index]);
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  addTransactions({required list}) {
    list.forEach((item) {
      transactionList.add(Transaction.fromJson(item));
    });
  }
}

class TransactionItem extends StatelessWidget {
  Transaction transaction;

  TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8.0, top: 4),
        child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            color: Colors.blueGrey,
                            size: 54,
                          ),
                          Text(transaction.date)
                        ]),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(transaction.status)
                        ]),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Service",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(transaction.serviceName)
                        ]),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(transaction.amount)
                        ]),
                  ],
                ))));
  }
}

class Transaction {
  String bankAccountID;
  String status;
  String serviceName;
  String date;
  String amount;

  Transaction(
      {required this.bankAccountID,
      required this.status,
      required this.serviceName,
      required this.date,
      required this.amount});

  Transaction.fromJson(Map<String, dynamic> json)
      : bankAccountID = json["BankAccountID"],
        status = json["Status"],
        serviceName = json["ServiceName"],
        date = json["Date"],
        amount = json["Amount"];
}

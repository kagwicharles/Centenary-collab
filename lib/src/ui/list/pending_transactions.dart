import 'package:flutter/material.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/user_model.dart';

class PendingTransactionList extends StatefulWidget {
  PendingTransactionList({Key? key, required this.moduleName})
      : super(key: key);

  String moduleName;

  @override
  State<PendingTransactionList> createState() => _PendingTransactionListState();
}

class _PendingTransactionListState extends State<PendingTransactionList> {
  final _pendingTransactionRepository = PendingTrxDisplayRepository();

  @override
  void initState() {
    super.initState();
  }

  getPendingTransactions() =>
      _pendingTransactionRepository.getAllPendingTransactions();

  @override
  Widget build(BuildContext context) {
    debugPrint("Transactions...$PendingTransactionList");
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.moduleName),
        ),
        body: FutureBuilder<List<PendingTrxDisplay>>(
            future: getPendingTransactions(),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context,
                AsyncSnapshot<List<PendingTrxDisplay>> snapshot) {
              Widget child = SizedBox();
              if (snapshot.hasData) {
                var pendingTransactions = snapshot.data;
                child = ListView.builder(
                  itemCount: pendingTransactions?.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(
                        transaction: pendingTransactions![index]);
                  },
                );
              }
              return child;
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TransactionItem extends StatelessWidget {
  PendingTrxDisplay transaction;

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
                        children: const [
                          Icon(
                            Icons.receipt_long,
                            color: Colors.blueGrey,
                            size: 54,
                          ),
                        ]),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transaction",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(transaction.transactionType)
                        ]),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Send To",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(transaction.sendTo)
                        ]),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(transaction.name)
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
                          Text(transaction.amount.toString())
                        ]),
                  ],
                ))));
  }
}

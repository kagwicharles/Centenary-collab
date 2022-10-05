import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/user_model.dart';
import 'package:rafiki/src/ui/home/credit_card.dart';

class TopHomeWidget extends StatefulWidget {
  @override
  State<TopHomeWidget> createState() => _TopHomeWidgetState();
}

class _TopHomeWidgetState extends State<TopHomeWidget>
    with SingleTickerProviderStateMixin {
  bool viewCreditCardState = true;
  final _bankAccountRepository = BankAccountRepository();

  var transitionBuilder = (Widget child, Animation<double> animation) {
    // return ScaleTransition(scale: animation, child: child);
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  };

  getBankAccounts() => _bankAccountRepository.getAllBankAccounts();

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
                  ? AnimatedSwitcher(
                      transitionBuilder: transitionBuilder,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                          // This key causes the AnimatedSwitcher to interpret this as a "new"
                          // child each time the count changes, so that it will begin its animation
                          // when the count changes.
                          key: ValueKey<bool>(viewCreditCardState),
                          height: 177,
                          constraints: const BoxConstraints(maxWidth: 277),
                          child: FutureBuilder<List<BankAccount>>(
                              future: getBankAccounts(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<BankAccount>> snapshot) {
                                Widget child = SizedBox();
                                if (snapshot.hasData) {
                                  var bankAccounts = snapshot.data;
                                  child = Swiper(
                                      scrollDirection: Axis.horizontal,
                                      autoplay: false,
                                      autoplayDelay: 5000,
                                      itemCount: bankAccounts?.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CreditCardWidget(
                                            bankAccountID: bankAccounts![index]
                                                .bankAccountId);
                                      });
                                }
                                return child;
                              })))
                  : AnimatedSwitcher(
                      transitionBuilder: transitionBuilder,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                          // This key causes the AnimatedSwitcher to interpret this as a "new"
                          // child each time the count changes, so that it will begin its animation
                          // when the count changes.
                          key: ValueKey<bool>(viewCreditCardState),
                          height: 177,
                          constraints: const BoxConstraints(maxWidth: 277),
                          child: const Center(
                            child: Text("No alerts yet"),
                          )))
            ]));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

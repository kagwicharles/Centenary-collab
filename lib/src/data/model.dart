import 'package:flutter/material.dart';

class CreditCard {
  final String balance;
  final String currency;

  CreditCard({
    required this.balance,
    required this.currency,
  });

  CreditCard.fromMap(Map map)
      : this(
          balance: map['balance'],
          currency: map['currency'],
        );
}

class MenuItem {
  final String title;
  final String icon;

  MenuItem({required this.title, required this.icon});
}

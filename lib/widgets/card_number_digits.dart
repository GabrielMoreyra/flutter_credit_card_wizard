import 'package:flutter/material.dart';

class CardNumberDigits extends StatelessWidget {
  final String text;

  CardNumberDigits({
    @required this.text,
  }) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24.0,
        fontFamily: 'ShareTechMono-Regular',
        package: 'credit_card_wizard',
        color: Colors.blueGrey,
      ),
    );
  }
}

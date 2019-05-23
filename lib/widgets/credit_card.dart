import 'dart:math';

import 'package:credit_card_wizard/enums/card_side.dart';
import 'package:credit_card_wizard/models/credit_card_data.dart';
import 'package:flutter/material.dart';

import 'card_number_digits.dart';

class CreditCard extends StatefulWidget {
  final CardSide side;
  final CreditCardData data;

  CreditCard({
    @required this.side,
    @required this.data,
  })  : assert(side != null),
        assert(data != null);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {

  List<String> getCardNumber(String cardNumber) {
    if (cardNumber == null) {
      cardNumber = '';
    }
    print(cardNumber);
    cardNumber = cardNumber.replaceAll(' ', '');
    print(cardNumber);
    while (cardNumber.length < 16) {
      cardNumber += '*';
    }
    var list = List<String>();
    for (var i = 0; i <= 12; i += 4) {
      list.add(cardNumber.substring(i, i + 4));
    }
    return list;
  }

  String getCardholderName(String cardholderName) {
    if (cardholderName == null || cardholderName.isEmpty) {
      return 'NOMBRE Y APELLIDO';
    }
    return cardholderName;
  }

  String getValidThru(String validThru) {
    var placeholder = 'MM/AA';
    if (validThru == null || validThru.isEmpty) {
      return placeholder;
    }
    if (validThru.length < 5) {
      return validThru + placeholder.substring(validThru.length);
    }
    return validThru;
  }

  String getSecurityCode(String securityCode) {
    if (securityCode == null) {
      securityCode = '';
    }
    while (securityCode.length < 3) {
      securityCode += '*';
    }
    return securityCode;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(widget.side == CardSide.front ? 0.0 : pi),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4.0,
        color: Colors.grey[350],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2.0,
          child: Builder(
            builder: (context) {
              if (widget.side == CardSide.front) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: (MediaQuery.of(context).size.width / 2.0) / 2,
                      left: 0.0,
                      right: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getCardNumber(widget.data.cardNumber)
                              .map((num) => CardNumberDigits(text: num))
                              .toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24.0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              getCardholderName(widget.data.cardholderName),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              getValidThru(widget.data.validThru),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 20.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      top: 90.0,
                      left: 0.0,
                      right: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 48.0,
                          height: 30.0,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getSecurityCode(widget.data.securityCode),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16.0,
                                    fontFamily: 'ShareTechMono-Regular',
                                    package: 'credit_card_wizard',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

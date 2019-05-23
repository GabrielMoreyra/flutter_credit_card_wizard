library credit_card_wizard;

import 'dart:math';

import 'package:flutter/material.dart';

import 'enums/card_side.dart';
import 'input_formatters/masked_text_input_formatter.dart';
import 'models/credit_card_data.dart';
import 'widgets/card_text_field.dart';
import 'widgets/credit_card.dart';

class CreditCardWizard extends StatefulWidget {
  @override
  _CreditCardWizardState createState() => _CreditCardWizardState();
}

class _CreditCardWizardState extends State<CreditCardWizard>
    with TickerProviderStateMixin {
  bool _showingFront = true;
  AnimationController _animationController;
  Animation _animation;

  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentField = 0;

  final _cardNumberFormKey = GlobalKey<FormState>();
  final _cardholderNameFormKey = GlobalKey<FormState>();
  final _validThruFormKey = GlobalKey<FormState>();
  final _securityCodeFormKey = GlobalKey<FormState>();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardholderNameController = TextEditingController();
  TextEditingController _validThruController = TextEditingController();
  TextEditingController _securityCodeController = TextEditingController();
  FocusNode _cardNumberFocusNode = FocusNode();
  FocusNode _cardholderNameFocusNode = FocusNode();
  FocusNode _validThruFocusNode = FocusNode();
  FocusNode _securityCodeFocusNode = FocusNode();
  CreditCardData _creditCardData = CreditCardData();

  goToNextField({bool previous = false}) {
    switch (_currentField) {
      case 0:
        var valid = _cardNumberFormKey.currentState.validate();
        if (valid) {
          _currentField = 1;
          movePage(1).then((v) {
            _cardNumberFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_cardholderNameFocusNode);
          });
        }
        break;
      case 1:
        if (!previous) {
          var valid = _cardholderNameFormKey.currentState.validate();
          if (valid) {
            _currentField = 2;
            movePage(2).then((v) {
              _cardholderNameFocusNode.unfocus();
              FocusScope.of(context).requestFocus(_validThruFocusNode);
            });
          }
        } else {
          _currentField = 0;
          movePage(0).then((v) {
            _cardholderNameFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_cardNumberFocusNode);
          });
        }
        break;
      case 2:
        if (!previous) {
          var valid = _validThruFormKey.currentState.validate();
          if (valid) {
            _currentField = 3;
            movePage(3).then((v) {
              _animationController.forward();
              _validThruFocusNode.unfocus();
              FocusScope.of(context).requestFocus(_securityCodeFocusNode);
            });
          }
        } else {
          movePage(1).then((v) {
            _currentField = 1;
            _validThruFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_cardholderNameFocusNode);
          });
        }
        break;
      case 3:
        if (!previous) {
          var valid = _securityCodeFormKey.currentState.validate();
        } else {
          movePage(2).then((v) {
            _currentField = 2;
            _animationController.reverse();
            _securityCodeFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_validThruFocusNode);
          });
        }
        break;
    }
  }

  Future movePage(int page) async {
    await _pageController.animateToPage(page,
        duration: Duration(milliseconds: 350), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(() => setState(
        () => _creditCardData.cardNumber = _cardNumberController.text));
    _cardholderNameController.addListener(() => setState(
        () => _creditCardData.cardholderName = _cardholderNameController.text));
    _validThruController.addListener(() {
      setState(() => _creditCardData.validThru = _validThruController.text);
    });
    _securityCodeController.addListener(() => setState(
        () => _creditCardData.securityCode = _securityCodeController.text));

    _animationController = AnimationController(
      duration: Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 100.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    )..addListener(() {
        setState(() {
          if (_showingFront && _animation.value > 50.0) {
            _showingFront = false;
          } else if (!_showingFront && _animation.value < 50.0) {
            _showingFront = true;
          }
        });
      });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderNameController.dispose();
    _validThruController.dispose();
    _securityCodeController.dispose();
    _cardNumberFocusNode.dispose();
    _cardholderNameFocusNode.dispose();
    _validThruFocusNode.dispose();
    _securityCodeFocusNode.dispose();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animation,
          builder: (context, widget) {
            return Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY((pi * _animation.value) / 100),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    if (_showingFront) {
                      return CreditCard(
                        side: CardSide.front,
                        data: _creditCardData,
                      );
                    }
                    return CreditCard(
                      side: CardSide.back,
                      data: _creditCardData,
                    );
                  },
                ),
              ),
            );
          },
        ),
        Container(
          height: 60.0,
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Form(
                key: _cardNumberFormKey,
                child: CardTextField(
                  label: 'Número de tarjeta',
                  controller: _cardNumberController,
                  focusNode: _cardNumberFocusNode,
                  maxLength: 60,
                  inputFormatters: [
                    MaskedTextInputFormatter(
                      mask: 'xxxx xxxx xxxx xxxx',
                      separator: ' ',
                    ),
                  ],
                  onFieldSubmitted: (v) => goToNextField(),
                  validator: (value) {
                    if (value.isEmpty || value.length < 16) {
                      return 'Introduce los 16 dígitos del número de tu tarjeta';
                    }
                  },
                ),
              ),
              Form(
                key: _cardholderNameFormKey,
                child: CardTextField(
                  label: 'Nombre y apellido',
                  controller: _cardholderNameController,
                  focusNode: _cardholderNameFocusNode,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (v) => goToNextField(),
                  maxLength: 20,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Introduce tu nombre y apellido tal cual esté impreso en la tarjeta';
                    }
                  },
                ),
              ),
              Form(
                key: _validThruFormKey,
                child: CardTextField(
                  label: 'Fecha de expiración',
                  controller: _validThruController,
                  focusNode: _validThruFocusNode,
                  onFieldSubmitted: (v) => goToNextField(),
                  maxLength: 5,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Introduce una fecha válida';
                    }
                  },
                ),
              ),
              Form(
                key: _securityCodeFormKey,
                child: CardTextField(
                  label: 'Código de seguridad',
                  controller: _securityCodeController,
                  focusNode: _securityCodeFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (v) => goToNextField(),
                  maxLength: 3,
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Introduce el código de seguridad de 3 dígitos';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                onPressed: () => goToNextField(previous: true),
                child: Text('Atrás'),
              ),
              RaisedButton(
                onPressed: goToNextField,
                child: Text('Siguiente'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;

  CircleButton({
    @required this.icon,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        minWidth: 40.0,
        height: 40.0,
        shape: CircleBorder(),
        child: RaisedButton(
          onPressed: onPressed,
          child: icon,
          textColor: Colors.blueGrey,
          color: Colors.white,
        ),
      ),
    );
  }
}

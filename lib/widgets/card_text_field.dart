import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final Function onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  CardTextField({
    @required this.label,
    @required this.controller,
    @required this.focusNode,
    @required this.validator,
    @required this.maxLength,
    @required this.onFieldSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
  })  : assert(label != null),
        assert(controller != null),
        assert(focusNode != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        // validator: validator,
        keyboardType: keyboardType ?? TextInputType.number,
        textInputAction: textInputAction ?? TextInputAction.next,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
        onFieldSubmitted: onFieldSubmitted,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: label,
          hasFloatingPlaceholder: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

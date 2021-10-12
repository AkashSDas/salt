import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double verticalPadding;

  const ExpandedButton({
    required this.text,
    required this.onPressed,
    this.verticalPadding = 16,
    Key? key,
  }) : super(key: key);

  ButtonStyle _style(BuildContext context) {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      backgroundColor: MaterialStateProperty.all(
        Theme.of(context).accentColor,
      ),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
        vertical: verticalPadding,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: _style(context),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Sofia Pro',
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          fontSize: 15,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class RoundedCornerButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double verticalPadding;
  final double horizontalPadding;

  const RoundedCornerButton({
    required this.onPressed,
    required this.text,
    this.verticalPadding = 16,
    this.horizontalPadding = 0,
    Key? key,
  }) : super(key: key);

  /// btn style
  ButtonStyle _style(BuildContext context) {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      backgroundColor: MaterialStateProperty.all(
        Theme.of(context).colorScheme.secondary,
      ),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
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
        style: const TextStyle(
          color: Colors.white,
          fontFamily: DesignSystem.fontHead,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          fontSize: 15,
        ),
      ),
    );
  }
}

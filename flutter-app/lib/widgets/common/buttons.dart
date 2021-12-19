import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double verticalPadding;
  final double horizontalPadding;
  final void Function()? onPressed;

  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.verticalPadding = 20,
    this.horizontalPadding = 0,
    Key? key,
  }) : super(key: key);

  // btn style
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
      child: Text(text, style: DesignSystem.button),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final double verticalPadding;
  final double horizontalPadding;
  final void Function()? onPressed;

  const SecondaryButton({
    required this.text,
    required this.onPressed,
    this.verticalPadding = 14,
    this.horizontalPadding = 0,
    Key? key,
  }) : super(key: key);

  // btn style
  ButtonStyle _style(BuildContext context) {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      backgroundColor: MaterialStateProperty.all(
        Theme.of(context).cardColor,
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
      child: Text(text, style: DesignSystem.button),
    );
  }
}

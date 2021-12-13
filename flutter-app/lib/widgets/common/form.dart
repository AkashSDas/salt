import 'package:flutter/material.dart';

import '../../design_system.dart';

class FormLabel extends StatelessWidget {
  final String label;
  const FormLabel({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(label, style: DesignSystem.medium),
    );
  }
}

class IconFormInput extends StatelessWidget {
  final Icon prefixIcon;
  final String label;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;

  const IconFormInput({
    required this.prefixIcon,
    required this.label,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  InputDecoration _inputDecoration(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
    );

    var hintStyle = DesignSystem.bodyIntro.copyWith(
      color: DesignSystem.placeholder,
    );
    var errorStyle = DesignSystem.caption.copyWith(
      color: DesignSystem.error,
    );

    return InputDecoration(
      fillColor: Theme.of(context).cardColor,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      border: border,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormLabel(label: label),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: (value) => onChanged(value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: _inputDecoration(context),
            cursorColor: Theme.of(context).colorScheme.secondary,
            style: DesignSystem.bodyIntro.copyWith(color: DesignSystem.text1),
          ),
        ),
      ],
    );
  }
}

class DateFormInput extends StatelessWidget {
  final Icon prefixIcon;
  final String label;
  final String hintText;
  final Color hintColor;
  final void Function() onTap;

  const DateFormInput({
    required this.prefixIcon,
    required this.onTap,
    required this.label,
    required this.hintText,
    required this.hintColor,
    Key? key,
  }) : super(key: key);

  InputDecoration _inputDecoration(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
    );

    var hintStyle = DesignSystem.bodyIntro.copyWith(
      color: hintColor,
    );
    var errorStyle = DesignSystem.caption.copyWith(
      color: DesignSystem.error,
    );

    return InputDecoration(
      fillColor: Theme.of(context).cardColor,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      border: border,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      prefixIcon: prefixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormLabel(label: label),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextFormField(
            onTap: onTap,
            decoration: _inputDecoration(context),
            focusNode: AlwaysDisabledFocusNode(),
            enableInteractiveSelection: false,
          ),
        ),
      ],
    );
  }
}

/// To disable foucs on editing a input but keeping the other
/// gestures available on text form input
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class RegularInputField extends StatelessWidget {
  final String label;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String hintText;

  const RegularInputField({
    required this.label,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  /// WIDGETS ///

  InputDecoration _inputDecoration(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
    );

    var hintStyle = DesignSystem.bodyIntro.copyWith(
      color: DesignSystem.tundora.withOpacity(0.45),
    );
    var errorStyle = DesignSystem.caption.copyWith(
      color: DesignSystem.radicalRed,
    );

    return InputDecoration(
      fillColor: DesignSystem.gallery,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      border: border,
      hintStyle: hintStyle,
      errorStyle: errorStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Label(label: label),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: (value) => onChanged(value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: _inputDecoration(context),
            cursorColor: DesignSystem.tundora,
            style: DesignSystem.bodyIntro,
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String label;
  const _Label({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(label, style: DesignSystem.heading4.copyWith(fontSize: 17)),
    );
  }
}

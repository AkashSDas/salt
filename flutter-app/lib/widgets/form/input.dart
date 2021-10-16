import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String hintText;

  const FormInputField({
    required this.label,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  /// WIDGETS ///

  Widget _buildLabel(BuildContext context) {
    var style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        );

    return Container(
      alignment: Alignment.centerLeft,
      child: Text(label, style: style),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );

    var hintStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
          color: DesignSystem.grey3.withOpacity(0.5),
        );

    return InputDecoration(
      fillColor: DesignSystem.grey1,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      border: border,
      hintStyle: hintStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLabel(context),
        SizedBox(height: 4),
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
            cursorColor: DesignSystem.grey3,
          ),
        ),
      ],
    );
  }
}

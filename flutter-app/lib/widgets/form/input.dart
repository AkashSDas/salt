import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';

class FormInputField extends StatelessWidget {
  const FormInputField(
      this.name, this.hintText, this.text, this.validator, this.formData,
      {Key? key, this.keyboardType, this.obscureText = false})
      : super(key: key);

  final String name; // name of the field
  final String text;
  final String hintText;
  final String? Function(String?)? validator;
  final Map<String, String> formData;
  final TextInputType? keyboardType;
  final bool obscureText;

  Widget _label(BuildContext context) => Container(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      );

  InputDecoration _inputDecoration(BuildContext context) => InputDecoration(
        fillColor: DesignSystem.grey1,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        // border: InputBorder.none,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: DesignSystem.grey3.withOpacity(0.5),
            ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _label(context),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: (value) {
              formData[name] = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: _inputDecoration(context),
          ),
        ),
      ],
    );
  }
}

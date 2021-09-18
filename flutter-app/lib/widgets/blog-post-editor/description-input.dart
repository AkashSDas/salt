import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/widgets/blog-post-editor/label.dart';

class DescriptionFormInput extends StatelessWidget {
  final String name; // name of the field
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final Map<String, String> formData;

  const DescriptionFormInput({
    required this.name,
    required this.label,
    required this.hintText,
    required this.formData,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInputLabel(label: label),
        _buildInput(context),
      ],
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          formData[name] = value;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        decoration: _inputDecoration(context),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: DesignSystem.grey4, fontWeight: FontWeight.w500),

        /// To use auto wrap instead of making the field scrollable
        maxLines: null,
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: DesignSystem.grey3.withOpacity(0.4),
          ),
      contentPadding: EdgeInsets.only(top: 4, bottom: 0),
    );
  }
}

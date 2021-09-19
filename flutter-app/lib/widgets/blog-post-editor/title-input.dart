import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/widgets/blog-post-editor/label.dart';

class TitleFormInput extends StatelessWidget {
  TitleFormInput({Key? key}) : super(key: key);

  final _validator = MultiValidator([
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(
      6,
      errorText: 'Title should be atleast 6 characters long',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormInputLabel(label: 'Title'),
        _buildTitleInput(context),
      ],
    );
  }

  Widget _buildTitleInput(BuildContext context) {
    BlogPostEditorProvider _provider = Provider.of<BlogPostEditorProvider>(
      context,
    );

    return Container(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) => _provider.updateTitle(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _validator,
        decoration: _inputDecoration(context),
        style: Theme.of(context)
            .textTheme
            .headline1
            ?.copyWith(color: DesignSystem.grey4),

        /// To use auto wrap instead of making the field scrollable
        maxLines: null,
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'Cool title',
      hintStyle: Theme.of(context).textTheme.headline1?.copyWith(
            color: DesignSystem.grey3.withOpacity(0.4),
          ),
      contentPadding: EdgeInsets.only(top: 4, bottom: 0),
    );
  }
}

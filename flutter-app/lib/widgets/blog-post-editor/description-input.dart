import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/blog-post-editor.dart';
import 'package:salt/widgets/blog-post-editor/label.dart';

/// Description
class BlogPostEditorFormDescriptionInput extends StatelessWidget {
  BlogPostEditorFormDescriptionInput({Key? key}) : super(key: key);

  final _validator = MultiValidator([
    RequiredValidator(errorText: 'Description is required'),
    MinLengthValidator(
      6,
      errorText: 'Description should be atleast 6 characters long',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlogPostFormLabel(label: 'Description'),
        _buildInput(context),
      ],
    );
  }

  Widget _buildInput(BuildContext context) {
    BlogPostEditorFormProvider _provider =
        Provider.of<BlogPostEditorFormProvider>(context);

    return Container(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) => _provider.updateTextInput('description', value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _validator,
        decoration: _inputDecoration(context),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: DesignSystem.grey4, fontWeight: FontWeight.w500),

        /// To use auto wrap instead of making the field scrollable
        maxLines: null,
        initialValue: _provider.description,
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'This is how it is done!',
      hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: DesignSystem.grey3.withOpacity(0.4),
          ),
      contentPadding: EdgeInsets.only(top: 4, bottom: 0),
    );
  }
}

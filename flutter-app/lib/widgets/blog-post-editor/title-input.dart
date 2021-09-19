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

        /// initialValue should be provided as it will not only initialValue
        /// but also the value that we'll see in the UI once the widget goes
        /// from being visible (when we enter value) to not being visibe
        /// (when we've scroll down) to again being visible (when we've
        /// scroll up to the widget, at this time if we've not set the initialValue
        /// then is high chance that the input field will be empty, Note that
        /// value of _provider.title won't change just the value in input field
        /// will be null, reason which I think of is when the widget mounts initially
        /// it has no value, then we enter value in it and the values simultaneously
        /// updates in the provider and when we scroll down the widget unmounts
        /// (performance reasons, as it happens in ListView) and when we scroll back
        /// to the widget the widget mounts again but with initialValue which If we
        /// don't set, then it will empty string). Overall to avoid this give
        /// initialValue as below
        initialValue: _provider.title,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/post_editor.dart';
import 'package:salt/utils/post_editor.dart';
import 'package:salt/widgets/common/form.dart';

import '../../design_system.dart';

/// Title input field
class TitleInputField extends StatelessWidget {
  final _validator = PostFormValidators().title;
  TitleInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel(label: 'Title'),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (value) => _p.setTitle(value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validator,
          decoration: _decoration(context),
          style: DesignSystem.heading1,

          /// To use auto wrap instead of making the field scrollable
          maxLines: null,

          /// initialValue should be provided as it will not only be initialValue
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
          initialValue: _p.title,
          cursorColor: DesignSystem.secondary,
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'Cool title',
      hintStyle: DesignSystem.heading1.copyWith(
        color: DesignSystem.placeholder,
      ),
      errorStyle: DesignSystem.caption.copyWith(color: DesignSystem.error),
    );
  }
}

/// Description input field
class DescriptionInputField extends StatelessWidget {
  final _validator = PostFormValidators().description;
  DescriptionInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel(label: 'Description'),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (value) => _p.setDescription(value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validator,
          decoration: _decoration(context),
          style: DesignSystem.bodyIntro.copyWith(
            height: 1.35,
            color: DesignSystem.text1,
          ),
          maxLines: null,
          initialValue: _p.description,
          cursorColor: DesignSystem.secondary,
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'This is how it is done!',
      hintStyle: DesignSystem.bodyIntro.copyWith(
        color: DesignSystem.placeholder,
      ),
      errorStyle: DesignSystem.caption.copyWith(color: DesignSystem.error),
    );
  }
}

/// Content input field
class ContentInputField extends StatelessWidget {
  final _validator = PostFormValidators().content;
  ContentInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel(label: 'Content'),
        TextFormField(
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          onChanged: (value) => _p.setContent(value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validator,
          decoration: _decoration(context),
          maxLines: 8,
          initialValue: _p.content,
          style: DesignSystem.bodyIntro.copyWith(
            fontWeight: FontWeight.w400,
            color: DesignSystem.text1,
          ),
          cursorColor: DesignSystem.secondary,
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'Amazing content goes here',
      hintStyle: DesignSystem.bodyIntro.copyWith(
        color: DesignSystem.placeholder,
      ),
      errorStyle: DesignSystem.caption.copyWith(color: DesignSystem.error),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/blog_post_editor.dart';
import 'package:salt/utils/blog_post_editor.dart';

class Label extends StatelessWidget {
  final String label;
  const Label({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(label, style: DesignSystem.heading4.copyWith(fontSize: 17)),
    );
  }
}

class TitleInputField extends StatelessWidget {
  final _validator = BlogPostEditorForm().title;
  TitleInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: 'Title'),
        // const SizedBox(height: 8),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (value) => _p.updateFormValue('title', value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validator,
          decoration: _decoration(context),
          style: DesignSystem.heading1,

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
          initialValue: _p.title,
          cursorColor: DesignSystem.tundora,
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'Cool title',
      hintStyle: DesignSystem.heading1.copyWith(
        color: DesignSystem.tundora.withOpacity(0.45),
      ),
      errorStyle: DesignSystem.caption.copyWith(color: DesignSystem.radicalRed),
    );
  }
}

class DescriptionInputField extends StatelessWidget {
  final _validator = BlogPostEditorForm().description;
  DescriptionInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: 'Description'),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          onChanged: (value) => _p.updateFormValue('description', value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validator,
          decoration: _decoration(context),
          style: DesignSystem.bodyIntro,
          maxLines: null,
          initialValue: _p.description,
          cursorColor: DesignSystem.tundora,
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'This is how it is done!',
      hintStyle: DesignSystem.bodyIntro.copyWith(
        color: DesignSystem.tundora.withOpacity(0.45),
      ),
      errorStyle: DesignSystem.caption.copyWith(color: DesignSystem.radicalRed),
    );
  }
}

class ContentInputField extends StatelessWidget {
  final _validator = BlogPostEditorForm().content;
  ContentInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlogPostEditorCreateProvider _p = Provider.of<BlogPostEditorCreateProvider>(
      context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: 'Content'),
        TextFormField(
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          onChanged: (value) => _p.updateFormValue('content', value),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validator,
          decoration: _decoration(context),
          maxLines: 8,
          initialValue: _p.content,
          style: DesignSystem.bodyIntro,
          cursorColor: DesignSystem.tundora,
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: 'Amazing content goes here',
      hintStyle: DesignSystem.bodyIntro.copyWith(
        color: DesignSystem.tundora.withOpacity(0.45),
      ),
      errorStyle: DesignSystem.caption.copyWith(color: DesignSystem.radicalRed),
    );
  }
}

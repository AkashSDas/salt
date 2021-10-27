import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/recipe_editor.dart';
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
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

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
          maxLines: null,
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
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

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
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

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

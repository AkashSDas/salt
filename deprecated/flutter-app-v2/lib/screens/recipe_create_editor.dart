import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/recipe_editor.dart';
import 'package:salt/widgets/recipe_editor.dart/table.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/recipe_editor.dart/form.dart';
import 'package:salt/widgets/recipe_editor.dart/btns.dart';
import 'package:salt/widgets/recipe_editor.dart/food_category_tag.dart';
import 'package:salt/widgets/recipe_editor.dart/food_category_dropdown.dart';
import 'package:salt/widgets/recipe_editor.dart/ingredient_form.dart';

class RecipeCreateEditorScreen extends StatelessWidget {
  const RecipeCreateEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeEditorProvider(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleInputField(),
              const SizedBox(height: 32),
              DescriptionInputField(),
              const SizedBox(height: 32),
              const FoodCategoryDropDown(),
              const SizedBox(height: 8),
              const FoodCategoryTag(),
              const SizedBox(height: 32),
              const _CoverImgViewer(),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    CoverImagePickerButton(),
                    const SizedBox(width: 8),
                    const PreviewContentButton(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              IngredientTable(),
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final provider = Provider.of<RecipeEditorProvider>(
                  context,
                  listen: false,
                );

                return SizedBox(
                  width: 144,
                  child: Expanded(
                    child: RoundedCornerIconButton(
                      icon: const SizedBox(
                        height: 24,
                        width: 24,
                        child: FlareActor(
                          'assets/flare-icons/plus.flr',
                          alignment: Alignment.center,
                          animation: 'idle',
                          sizeFromArtboard: true,
                        ),
                      ),
                      onPressed: () {
                        showBottomSheet(
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                            value: provider,
                            child: const IngredientForm(),
                          ),
                        );
                      },
                      text: 'Add',
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              const _ContentViewer(),
              const SizedBox(height: 32),
              const SizedBox(
                height: 54,
                width: double.infinity,
                child: SaveButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentViewer extends StatelessWidget {
  const _ContentViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    if (_p.previewContent) {
      return Markdown(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        data: '**${_p.content[0].toUpperCase()}**${_p.content.substring(1)}',
        styleSheet: MarkdownStyleSheet(
          h1: DesignSystem.heading1,
          h2: DesignSystem.heading2,
          h3: DesignSystem.heading3,
          h4: DesignSystem.heading4,
          p: DesignSystem.bodyIntro,
        ),
      );
    }

    return ContentInputField();
  }
}

class _CoverImgViewer extends StatelessWidget {
  const _CoverImgViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    if (_p.coverImgFile.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: DesignSystem.gallery,
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: Image.file(File(_p.coverImgFile[0].path)).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

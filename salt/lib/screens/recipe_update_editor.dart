import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/models/food_category/food_category.dart';
import 'package:salt/models/recipe/recipe.dart';
import 'package:salt/providers/recipe_editor.dart';
import 'package:salt/utils/recipe_editor.dart';
import 'package:salt/widgets/recipe_editor.dart/table.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/recipe_editor.dart/form.dart';
import 'package:salt/widgets/recipe_editor.dart/btns.dart';
import 'package:salt/widgets/recipe_editor.dart/food_category_tag.dart';
import 'package:salt/widgets/recipe_editor.dart/ingredient_form.dart';

class RecipeUpdateEditorScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeUpdateEditorScreen({
    required this.recipe,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeEditorProvider.fromRecipe(
        title: recipe.title,
        description: recipe.description,
        content: recipe.content,
        tags: recipe.categories,
        ingredients: recipe.ingredients.map(
          (data) {
            return RecipeIngredient(
              name: data.name,
              description: data.description,
              qunatity: data.quantity,
            );
          },
        ).toList(),
      ),
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
              const _FoodCategoryDropDown(),
              const SizedBox(height: 8),
              const FoodCategoryTag(),
              const SizedBox(height: 32),
              _CoverImgViewer(coverImgURL: recipe.coverImgURL),
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
  final String coverImgURL;

  const _CoverImgViewer({
    required this.coverImgURL,
    Key? key,
  }) : super(key: key);

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
          image: _p.coverImgFile.isNotEmpty
              ? Image.file(File(_p.coverImgFile[0].path)).image
              : NetworkImage(coverImgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// FOOD CATEGORY

class _FoodCategoryDropDown extends StatefulWidget {
  const _FoodCategoryDropDown({Key? key}) : super(key: key);

  @override
  State<_FoodCategoryDropDown> createState() => __FoodCategoryDropDownState();
}

class __FoodCategoryDropDownState extends State<_FoodCategoryDropDown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<RecipeEditorProvider>(
        context,
        listen: false,
      ).fetchAllFoodCategoriedFiltered();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: DesignSystem.gallery,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const _DropDownBtn(),
    );
  }
}

class _DropDownBtn extends StatelessWidget {
  const _DropDownBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<RecipeEditorProvider>(context);

    var items = <FoodCategory>[..._p.foodCategories].map((FoodCategory value) {
      return DropdownMenuItem<String>(
        key: Key(value.id),
        value: value.id,
        child: Text(
          '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
          style: DesignSystem.bodyMain,
        ),
      );
    }).toList();

    return DropdownButton<String>(
      underline: const SizedBox(),
      isExpanded: true,
      icon: const _DropDownIcon(),
      elevation: 4,
      value: null,
      hint: Text('Select tags', style: DesignSystem.caption),
      items: items,
      onChanged: (id) {
        if (id != null) {
          var selectedCategory = _p.foodCategories
              .where(
                (category) => category.id == id,
              )
              .toList();

          if (selectedCategory.isNotEmpty) {
            _p.addTag(selectedCategory[0]);
            _p.removeFoodCategory(selectedCategory[0].id);
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      dropdownColor: DesignSystem.white,
    );
  }
}

class _DropDownIcon extends StatelessWidget {
  const _DropDownIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<RecipeEditorProvider>(context);

    if (_p.foodCategoriesLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(),
      );
    }

    return const Icon(Icons.arrow_drop_down_circle_outlined);
  }
}

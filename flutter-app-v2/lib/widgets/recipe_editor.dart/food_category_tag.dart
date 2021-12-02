import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/recipe_editor.dart';

class FoodCategoryTag extends StatelessWidget {
  const FoodCategoryTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        _p.tags.length,
        (index) => Container(
          height: 44,
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffBDBDBD), width: 0.5),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TagEmoji(emoji: _p.tags[index].emoji),
              const SizedBox(width: 8),
              Text(
                '${_p.tags[index].name[0].toUpperCase()}${_p.tags[index].name.substring(1)}',
                style: DesignSystem.caption.copyWith(
                  color: DesignSystem.caption.color!.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 8),
              _CancelBtn(tagIndex: index)
            ],
          ),
        ),
      ),
    );
  }
}

class _TagEmoji extends StatelessWidget {
  final String emoji;
  const _TagEmoji({required this.emoji, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
        color: Theme.of(context).primaryColor,
      ),
      child: Center(child: Text(emoji)),
    );
  }
}

class _CancelBtn extends StatelessWidget {
  final int tagIndex;
  const _CancelBtn({required this.tagIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    return GestureDetector(
      onTap: () {
        _p.addFoodCategory(_p.tags[tagIndex]);
        _p.removeTag(_p.tags[tagIndex].id);
      },
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: DesignSystem.gallery,
        ),
        child: const Center(
          child: Icon(Icons.cancel, color: DesignSystem.tundora),
        ),
      ),
    );
  }
}

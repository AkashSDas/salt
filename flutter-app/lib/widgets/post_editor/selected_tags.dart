import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/post_editor.dart';

class SelectedTags extends StatelessWidget {
  const SelectedTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          _p.selectedTags.length,
          (index) => Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: DesignSystem.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_p.selectedTags[index].emoji} ${_p.selectedTags[index].name[0].toUpperCase()}${_p.selectedTags[index].name.substring(1)}',
                  style: DesignSystem.caption,
                ),
                const SizedBox(width: 8),
                _CancelBtn(tagIndex: index)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelBtn extends StatelessWidget {
  final int tagIndex;
  const _CancelBtn({required this.tagIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    return GestureDetector(
      onTap: () {
        _p.addTag(_p.selectedTags[tagIndex]);
        _p.removeSelectedTag(_p.selectedTags[tagIndex].id);
      },
      child: const Icon(IconlyLight.close_square),
    );
  }
}

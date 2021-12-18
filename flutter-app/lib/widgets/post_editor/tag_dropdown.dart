import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/providers/post_editor.dart';

import '../../design_system.dart';

class TagDropDown extends StatefulWidget {
  const TagDropDown({Key? key}) : super(key: key);

  @override
  _TagDropDownState createState() => _TagDropDownState();
}

class _TagDropDownState extends State<TagDropDown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<PostEditorProvider>(
        context,
        listen: false,
      ).getAllTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DesignSystem.border,
        borderRadius: BorderRadius.circular(16),
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
    final _p = Provider.of<PostEditorProvider>(context);
    var items = <Tag>[..._p.tags].map((Tag value) {
      return DropdownMenuItem<String>(
        key: Key(value.id),
        value: value.id,
        child: Text(
          '${value.emoji} ${value.name[0].toUpperCase()}${value.name.substring(1)}',
          style: DesignSystem.medium,
        ),
      );
    }).toList();

    return DropdownButton<String>(
      underline: const SizedBox(),
      isExpanded: true,
      icon: const _DropDownIcon(),
      elevation: 4,
      value: null,
      hint: Text('Select tags', style: DesignSystem.medium),
      items: items,
      onChanged: (id) {
        if (id != null) {
          var selectedTag = _p.tags.where((t) => t.id == id).toList();
          if (selectedTag.isNotEmpty) {
            _p.addSelectedTag(selectedTag[0]);
            _p.removeTag(selectedTag[0].id);
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      dropdownColor: DesignSystem.card,
    );
  }
}

class _DropDownIcon extends StatelessWidget {
  const _DropDownIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<PostEditorProvider>(context);

    if (_p.tagLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(),
      );
    }

    return const Icon(IconlyLight.arrow_down_circle);
  }
}

class SelectedTagDropDown extends StatefulWidget {
  const SelectedTagDropDown({Key? key}) : super(key: key);

  @override
  _SelectedTagDropDownState createState() => _SelectedTagDropDownState();
}

class _SelectedTagDropDownState extends State<SelectedTagDropDown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<PostEditorProvider>(
        context,
        listen: false,
      ).getAllTagsFiltered();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DesignSystem.border,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const _DropDownBtn(),
    );
  }
}

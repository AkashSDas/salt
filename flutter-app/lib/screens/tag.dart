import 'package:flutter/material.dart';
import 'package:salt/models/tag/tag.dart';
import 'package:salt/services/tag.dart';
import 'package:salt/utils/api.dart';
import 'package:salt/widgets/common/loader.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

import '../design_system.dart';

class TagScreen extends StatelessWidget {
  final String tagId;
  TagScreen({required this.tagId, Key? key}) : super(key: key);

  final _service = TagService();

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      children: [
        FutureBuilder(
          future: _service.getTag(tagId),
          builder: (context, AsyncSnapshot<ApiResponse> snapshot) {
            if (!snapshot.hasData) return const SearchLoader();
            final response = snapshot.data;
            if (response == null) return const SearchLoader();
            if (response.error || response.data == null) {
              return const SearchLoader();
            }
            final tag = Tag.fromJson(response.data['tag']);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(
                        tag.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${tag.name[0].toUpperCase()}${tag.name.substring(1)}',
                    style: DesignSystem.heading3,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: DesignSystem.border),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Buy ',
                        style: DesignSystem.heading4,
                        children: [
                          TextSpan(
                            text: tag.name,
                            style: DesignSystem.heading4.copyWith(
                              color: DesignSystem.secondary,
                            ),
                          ),
                          const TextSpan(text: ' product'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

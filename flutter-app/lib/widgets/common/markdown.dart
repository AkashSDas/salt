import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:salt/design_system.dart';
import 'package:salt/widgets/common/divider.dart';

class MarkdownContent extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const MarkdownContent({
    Key? key,
    required this.text,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      padding: padding == null ? const EdgeInsets.all(0) : padding!,
      shrinkWrap: shrinkWrap,
      physics: physics,
      data: text,
      styleSheet: MarkdownStyleSheet(
        h1: DesignSystem.heading2,
        h2: DesignSystem.heading3,
        h3: DesignSystem.heading4,
        h4: DesignSystem.bodyIntro.copyWith(color: DesignSystem.text1),
        p: DesignSystem.bodyMain,
        blockquoteDecoration: BoxDecoration(
          color: DesignSystem.card,
          borderRadius: BorderRadius.circular(8),
        ),
        blockSpacing: 20,
        listBullet: DesignSystem.bodyMain,
        code: DesignSystem.bodyMain.copyWith(
          color: DesignSystem.secondary,
        ),
        horizontalRuleDecoration: ShapeDecoration(
          color: DesignSystem.border,
          shape: Border.all(color: DesignSystem.border),
        ),
      ),
    );
  }
}

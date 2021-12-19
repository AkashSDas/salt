import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:salt/design_system.dart';

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
        h1: DesignSystem.heading1,
        h2: DesignSystem.heading2,
        h3: DesignSystem.heading3,
        h4: DesignSystem.heading4,
        p: DesignSystem.bodyIntro,
      ),
    );
  }
}

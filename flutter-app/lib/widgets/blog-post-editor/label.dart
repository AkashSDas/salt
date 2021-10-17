import 'package:flutter/material.dart';

/// Label
class BlogPostFormLabel extends StatelessWidget {
  final String label;
  const BlogPostFormLabel({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: Colors.black,
        );

    return Container(
      alignment: Alignment.centerLeft,
      child: Text(label, style: _style),
    );
  }
}

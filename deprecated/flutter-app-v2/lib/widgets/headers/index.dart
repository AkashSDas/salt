import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class Heading extends StatelessWidget {
  final String title;
  const Heading({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: DesignSystem.heading4.copyWith(fontSize: 20),
    );
  }
}

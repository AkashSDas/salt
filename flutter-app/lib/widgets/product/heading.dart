import 'package:flutter/material.dart';

import '../../design_system.dart';

class GroceriesSectionHeading extends StatelessWidget {
  const GroceriesSectionHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Wanna buy ',
          style: DesignSystem.heading3,
          children: [
            TextSpan(
              text: 'groceries?',
              style: DesignSystem.heading3.copyWith(
                color: DesignSystem.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

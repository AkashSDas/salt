import 'package:flutter/material.dart';

class Promotion extends StatelessWidget {
  const Promotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _logo(context),
        SizedBox(height: 16),
        _slogan(context),
      ],
    );
  }

  /// Logo
  Widget _logo(BuildContext context) => Text(
        'salt',
        style: Theme.of(context).textTheme.headline1?.copyWith(
          fontSize: 60,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(
              offset: Offset(0, 16),
              blurRadius: 32,
              color: Color(0xffFFC21E).withOpacity(0.3),
            ),
            Shadow(
              offset: Offset(0, -8),
              blurRadius: 32,
              color: Color(0xffFFC21E).withOpacity(0.3),
            ),
          ],
        ),
      );

  /// Slogan
  Widget _slogan(BuildContext context) => Text(
        'All you need for your greedy stomach',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      );
}

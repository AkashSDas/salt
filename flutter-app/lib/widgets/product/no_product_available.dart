import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import '../../design_system.dart';

class NoProductAvailable extends StatelessWidget {
  const NoProductAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: SizedBox(
            height: 120,
            width: 120,
            child: FlareActor(
              'assets/flare/other-emojis/smiling-face-with-sunglasses.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'go',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No products available',
          style: DesignSystem.bodyIntro,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 128,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

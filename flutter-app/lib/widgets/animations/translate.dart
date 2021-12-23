import 'package:flutter/material.dart';
import 'package:spring/spring.dart';

class TranslateAnimation extends StatelessWidget {
  final Offset beginOffset;
  final Offset endOffset;
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const TranslateAnimation({
    Key? key,
    required this.beginOffset,
    required this.endOffset,
    this.delay = const Duration(seconds: 0),
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeInOut,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Spring.translate(
        beginOffset: beginOffset,
        endOffset: endOffset,
        child: child,
        curve: curve,
        delay: delay,
        animDuration: duration,
      ),
    );
  }
}

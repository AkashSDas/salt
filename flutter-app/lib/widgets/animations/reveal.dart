import 'package:flutter/material.dart';
import 'package:salt/widgets/animations/translate.dart';
import 'package:spring/spring.dart';

class RevealAnimation extends StatelessWidget {
  final int delay;
  final Widget child;
  final int duration;
  final double startAngle;
  final double startYOffset;

  const RevealAnimation({
    Key? key,
    this.delay = 0,
    this.duration = 0,
    this.startAngle = 0,
    this.startYOffset = 0,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Spring.rotate(
      startAngle: startAngle,
      endAngle: 0,
      animDuration: Duration(milliseconds: duration),
      delay: Duration(milliseconds: delay),
      curve: Curves.easeOut,
      child: TranslateAnimation(
        child: child,
        duration: Duration(milliseconds: duration),
        delay: Duration(milliseconds: delay),
        beginOffset: Offset(0, startYOffset),
        endOffset: const Offset(0, 0),
        curve: Curves.easeInOut,
      ),
    );
  }
}

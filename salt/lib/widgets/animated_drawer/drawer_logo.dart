import 'package:flutter/material.dart';
import 'package:salt/design_system.dart';

class DrawerLogo extends StatelessWidget {
  const DrawerLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 115,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: const [
          _LogoText(),
          _CircleGraphic(top: -20, left: -16, width: 52, height: 52),
          _CircleGraphic(top: -8, right: 30, width: 32, height: 32),
          _CircleGraphic(bottom: -16, left: -7, width: 42, height: 42),
          _CircleGraphic(bottom: 26, right: 32, width: 28, height: 28),
          _CircleGraphic(bottom: 21, right: -7, width: 16, height: 16),
          _CircleGraphic(bottom: 4, right: 8, width: 16, height: 16),
        ],
      ),
    );
  }
}

/// Circle graphics in logo
class _CircleGraphic extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  const _CircleGraphic({
    this.bottom,
    this.left,
    this.right,
    this.top,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _decoration = const BoxDecoration(
      color: Color(0xFF2D2D2D),
      shape: BoxShape.circle,
    );

    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      child: Container(width: width, height: height, decoration: _decoration),
    );
  }
}

/// Logo text
class _LogoText extends StatelessWidget {
  const _LogoText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 40,
      right: 0,
      left: 0,
      child: Text(
        'salt',
        style: TextStyle(
          color: Colors.white,
          fontFamily: DesignSystem.fontHead,
          fontWeight: FontWeight.w900,
          fontSize: 32,
          letterSpacing: 3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

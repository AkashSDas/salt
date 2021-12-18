import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';

class AnimateAppBarOnScroll extends StatelessWidget {
  final List<Widget> children;
  final int? bottomNavIdx;

  const AnimateAppBarOnScroll({
    required this.children,
    this.bottomNavIdx,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      child: _ListView(children: children),
      bottomNavIdx: bottomNavIdx,
    );
  }
}

class _ListView extends StatefulWidget {
  final List<Widget> children;
  const _ListView({required this.children, Key? key}) : super(key: key);

  @override
  __ListViewState createState() => __ListViewState();
}

class __ListViewState extends State<_ListView> {
  final ScrollController _ctrl = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _ctrl.addListener(() {
        var pixels = _ctrl.position.pixels;
        if (pixels >= 0) {
          /// Listview has be scrolled (when == 0 you're at top)
          Provider.of<AnimatedDrawerProvider>(
            context,
            listen: false,
          ).animateAppBar(pixels);
        }
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(controller: _ctrl, children: widget.children);
  }
}

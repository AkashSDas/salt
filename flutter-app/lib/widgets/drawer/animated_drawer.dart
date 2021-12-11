import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/index.dart';
import '../../providers/animated_drawer.dart';
import 'animated_appbar.dart';
import 'drawer_body.dart';

class AnimatedDrawer extends StatefulWidget {
  final Widget child;
  const AnimatedDrawer({required this.child, Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<AnimatedDrawer> with TickerProviderStateMixin {
  final animationDuration = const Duration(milliseconds: 200);

  late AnimationController bodyCtrl;
  late AnimationController drawerCtrl;

  /// This [tag] should be unique every time `AnimatedDrawer` is created
  /// because its going to be used as tag name parameter in `Get.put` for
  /// `drawerCtrl` and `bodyCtrl`
  ///
  /// If they are same then it ctrls will work only for the body of
  /// `AnimatedDrawer` which is mounted and for others it won't work. So its
  /// better to keep `ctrlId name` unique so that it works for a given
  /// `AnimatedDrawer`
  final String tag = createRandomString(10);

  // Init
  @override
  void initState() {
    super.initState();

    drawerCtrl = AnimationController(
      vsync: this,
      duration: animationDuration,
      value: 1,
    );
    Get.put(drawerCtrl, tag: 'drawerCtrl$tag', permanent: true);

    bodyCtrl = AnimationController(
      vsync: this,
      duration: animationDuration,
      value: 0,
    );
    Get.put(bodyCtrl, tag: 'bodyCtrl$tag', permanent: true);
  }

  // Dispose
  @override
  void dispose() {
    drawerCtrl.dispose();
    bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnimatedDrawerProvider(uniqueTag: tag),
      child: SafeArea(
        child: Scaffold(
          appBar: const AnimatedAppBar(),
          body: Stack(
            children: [
              const _DrawerBodyWrapper(),
              _BodyWrapper(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerBodyWrapper extends StatelessWidget {
  const _DrawerBodyWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _drawerCtrl = Get.find(
      tag: 'drawerCtrl${_provider.uniqueTag}',
    );

    return AnimatedBuilder(
      animation: _drawerCtrl,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          -MediaQuery.of(context).size.width * 0.5 * _drawerCtrl.value,
          0,
        ),
        child: const DrawerBody(),
      ),
    );
  }
}

class _BodyWrapper extends StatelessWidget {
  final Widget child;
  const _BodyWrapper({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _drawerCtrl = Get.find(
      tag: 'drawerCtrl${_provider.uniqueTag}',
    );
    AnimationController _bodyCtrl = Get.find(
      tag: 'bodyCtrl${_provider.uniqueTag}',
    );

    return AnimatedBuilder(
      animation: _bodyCtrl,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_provider.isOpen) {
              _provider.toggleDrawerState();
              _drawerCtrl.forward();
              _bodyCtrl.reverse();
            }
          },
          child: Transform.translate(
            offset: Offset(
              /// Width of body that will be visible when the drawer is open
              MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value,
              160 * _bodyCtrl.value,
            ),
            child: Container(
              /// Adding clip here to hide overflow of body
              clipBehavior: Clip.antiAlias,

              padding: EdgeInsets.symmetric(
                vertical: 16 * _bodyCtrl.value,
                horizontal: 16 * _bodyCtrl.value,
              ),
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor,
                color: Colors.yellow,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-16 * _bodyCtrl.value, 0),
                    blurRadius: 32 * _bodyCtrl.value,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.15),
                  ),
                ],
                borderRadius: BorderRadius.circular(50 * _bodyCtrl.value),
              ),
              child: AbsorbPointer(
                absorbing: _provider.isOpen ? true : false,
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

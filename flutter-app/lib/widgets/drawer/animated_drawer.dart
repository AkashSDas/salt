import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/utils/index.dart';
import 'package:salt/widgets/common/app_bottom_nav.dart';
import 'package:salt/widgets/drawer/animated_appbar.dart';
import 'package:salt/widgets/drawer/drawer_body.dart';

/// Give [bottomNavIdx] to display bottom nav on the screen and the active
/// icon will be on `index` equal to [bottomNavIdx]
class AnimatedDrawer extends StatefulWidget {
  final Widget child;
  final int? bottomNavIdx;

  const AnimatedDrawer({
    required this.child,
    this.bottomNavIdx,
    Key? key,
  }) : super(key: key);

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
          bottomNavigationBar: widget.bottomNavIdx != null
              ? AppBottomNav(currentIdx: widget.bottomNavIdx!)
              : null,
        ),
      ),
    );
  }
}

/// This wapper handles the animation for drawer
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

/// This is the wapper around the [child]
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
          child: _BodyAnimation(
            child: AbsorbPointer(
              absorbing: _provider.isOpen ? true : false,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// This will handle the animation of the body
class _BodyAnimation extends StatelessWidget {
  final Widget child;
  const _BodyAnimation({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<AnimatedDrawerProvider>(context);
    AnimationController _bodyCtrl = Get.find(
      tag: 'bodyCtrl${_provider.uniqueTag}',
    );

    /// `x` is the width of body which will be visible when the drawer is open
    var x = MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value;
    var y = 160 * _bodyCtrl.value;
    var pad = _padding(_bodyCtrl.value, _bodyCtrl.value);

    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: pad,
        decoration: _decoration(context, _bodyCtrl.value),
        child: AbsorbPointer(
          absorbing: _provider.isOpen ? true : false,
          child: child,
        ),
      ),
    );
  }

  /// Multiplying by `16` as that's the max `horizontal` and `vertical`
  /// padding
  EdgeInsets _padding(double x, double y) {
    return EdgeInsets.symmetric(vertical: 16 * y, horizontal: 16 * x);
  }

  BoxDecoration _decoration(BuildContext context, double _ctrlValue) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor,
      boxShadow: [
        BoxShadow(
          offset: Offset(-16 * _ctrlValue, 0),
          blurRadius: 32 * _ctrlValue,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
        ),
      ],
      borderRadius: BorderRadius.circular(50 * _ctrlValue),
    );
  }
}

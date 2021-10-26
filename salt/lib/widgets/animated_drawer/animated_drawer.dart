import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/animated_drawer/animated_appbar.dart';
import 'package:salt/widgets/animated_drawer/drawer_body.dart';
import 'package:get/get.dart';

class AnimatedDrawer extends StatefulWidget {
  final Widget body;

  /// This should be unique every time AnimatedDrawer is created
  /// because this is going to be used in tag of animation ctrls
  /// (drawer and body) tag name in Get.put and if they are same
  /// then it ctrls will work only for the body of AnimatedDrawer
  /// which is mounted and for others it won't work. So better keep
  /// ctrlId name unique so that it works for a given AnimatedDrawer
  final String tag;

  const AnimatedDrawer({
    required this.tag,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<AnimatedDrawer> with TickerProviderStateMixin {
  double appBarHeight = 64;
  final duration = const Duration(milliseconds: 200);

  /// TODO: use dependency injection for sending ctrls
  late AnimationController _bodyCtrl;
  late AnimationController _drawerCtrl;

  /// Init and Dispose

  @override
  void initState() {
    super.initState();

    _drawerCtrl = AnimationController(
      vsync: this,
      duration: duration,
      value: 1,
    );
    Get.put(
      _drawerCtrl,
      tag: 'animatedDrawerDrawerCtrl${widget.tag}',
      permanent: true,
    );

    _bodyCtrl = AnimationController(
      vsync: this,
      duration: duration,
      value: 0,
    );
    Get.put(
      _bodyCtrl,
      tag: 'animatedDrawerBodyCtrl${widget.tag}',
      permanent: true,
    );
  }

  @override
  void dispose() {
    _drawerCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnimatedDrawerProvider(ctrlTag: widget.tag),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AnimatedAppBar(bodyCtrl: _bodyCtrl, drawerCtrl: _drawerCtrl),
          body: Stack(
            children: [
              _buildDrawer(),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  /// Drawer
  Widget _buildDrawer() {
    return Builder(
      builder: (context) {
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
      },
    );
  }

  /// Body
  /// TODO: When drawer is opened no widget in this widget should be react to any click except for closing the drawer
  Widget _buildBody() {
    return Builder(
      builder: (context) {
        final AnimatedDrawerProvider _provider =
            Provider.of<AnimatedDrawerProvider>(context);

        return AnimatedBuilder(
          animation: _bodyCtrl,
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                if (_provider.isDrawerOpen) {
                  _provider.toggleDrawerState();
                  _drawerCtrl.forward();
                  _bodyCtrl.reverse();
                }
              },
              child: Transform.translate(
                offset: Offset(
                  /// Width of body that will be visible when the drawer is open
                  MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value,
                  128 * _bodyCtrl.value,
                ),
                child: Container(
                  /// Adding clip here to hide overflow of body
                  clipBehavior: Clip.antiAlias,

                  padding: EdgeInsets.symmetric(
                    vertical: 8 * _bodyCtrl.value,
                    horizontal: 8 * _bodyCtrl.value,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-16 * _bodyCtrl.value, 0),
                        blurRadius: 64 * _bodyCtrl.value,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.25),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16 * _bodyCtrl.value),
                  ),
                  child: AbsorbPointer(
                    absorbing: _provider.isDrawerOpen ? true : false,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: widget.body,
        );
      },
    );
  }
}

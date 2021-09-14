import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  bool isDrawerOpen;
  AnimationController drawerCtrl;
  AnimationController bodyCtrl;
  Function toggleDrawerState;

  final double appBarHeight = 64;

  CustomAppBar({
    required this.isDrawerOpen,
    required this.drawerCtrl,
    required this.bodyCtrl,
    required this.toggleDrawerState,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.drawerCtrl,
      builder: (context, child) => Container(
        alignment: Alignment.bottomCenter,
        color: Theme.of(context).primaryColor,
        height: widget.appBarHeight * widget.drawerCtrl.value,
        child: Container(
          height: widget.appBarHeight,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDrawerBtn(context),
              _buildPlaceholderBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerBtn(BuildContext context) => IconButton(
        icon: AspectRatio(
          aspectRatio: 1,
          child: FlareActor(
            'assets/flare/icons/static/filter.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'idle',
          ),
        ),
        color: Colors.black,
        onPressed: () {
          /// Any changes happening to widget.isDrawerOpen won't be reflected in Screen widget
          /// and any change happening in Screen widget won't be reflected here. This is
          /// because no global state is used (provider, etc can be used to achieve it)
          /// That's why widget.toggleDrawerState() (will update Screen widget isDrawerOpen value)
          /// and setState for widget.isDrawerOpen (will update widget.isDrawerOpen and not Screen
          /// widget's isDrawerOpen state) are called here together

          widget.toggleDrawerState();
          setState(() {
            widget.isDrawerOpen = !widget.isDrawerOpen;
          });
          if (widget.isDrawerOpen) {
            widget.drawerCtrl.reverse();
            widget.bodyCtrl.forward();
          } else {
            widget.drawerCtrl.forward();
            widget.bodyCtrl.reverse();
          }
        },
      );

  Widget _buildPlaceholderBtn(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.transparent,
        onPressed: () {},
      );
}

/// Drawer and Body with animations (drawer is a custom widget and not Drawer widget)
///
/// ---------------------------                                            ---------------------------------
/// |                         |                                            |                               |
/// |  ---------------------  |                                            |-----------   -----------------|
/// |  |                   |  |                                            |          |   |                |
/// |  |                   |  |      =============================||=>     |          |   |                |
/// |  |      BODY         |  |      === Animation (open drawer)==||=>     |  DRAWER  |   |   BODY         |
/// |  |                   |  |      =============================||=>     |          |   |                |
/// |  |                   |  |                                            |          |   |                |
/// |  ---------------------  |                                            |-----------   -----------------|
/// |                         |                                            |                               |
/// ---------------------------                                            ---------------------------------
///
///
/// BODY - widget where your content will be there (what you'll put in Scaffold's body)
/// DRAWER - not Flutter's Drawer widget but a container where you'll put drawer elements

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with TickerProviderStateMixin {
  bool isDrawerOpen = false;
  late AnimationController _drawerCtrl;
  late AnimationController _bodyCtrl;
  int animationDuration = 300;
  final double appBarHeight = 64;

  void toggleDrawerState() => setState(() => isDrawerOpen != isDrawerOpen);

  @override
  void initState() {
    super.initState();

    _drawerCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
      value: 1,
    );

    _bodyCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
      value: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(
          isDrawerOpen: isDrawerOpen,
          drawerCtrl: _drawerCtrl,
          bodyCtrl: _bodyCtrl,
          toggleDrawerState: toggleDrawerState,
        ),
        body: Stack(
          children: [
            _buildDrawer(context),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return AnimatedBuilder(
      animation: _drawerCtrl,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          /// 50% of media query width
          /// minus sign denotes that this initially this widget will be offset
          /// -50% out the screen to the left side, as the _drawerCtr
          /// initial value is 1. When the controller moves forward i.e.
          /// from 1 to 0, x position of drawer increase and when value of
          /// _drawerCtrl is 0 the drawer is in 0 position visible in the screen
          -MediaQuery.of(context).size.width * 0.5 * _drawerCtrl.value,
          // -appBarHeight * _drawerCtrl.value,

          /// Keep 0 will also do the work as the app bar height is decreasing when drawer is opened
          /// So this widget moves in upward direction as its y offset is 0
          0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return AnimatedBuilder(
      animation: _bodyCtrl,
      builder: (context, child) => GestureDetector(
        onTap: () {
          if (isDrawerOpen) {
            setState(() {
              isDrawerOpen = !isDrawerOpen;
            });
          }
          _drawerCtrl.forward();
          _bodyCtrl.reverse();
        },
        child: Transform.translate(
          offset: Offset(
            /// The initial value for _bodyCtrl is 0 so meaning that
            /// initially x position of this widget will 0 and as soon the
            /// animation starts value of _bodyCtrl will increase and move towards
            /// 1 which means this widget will be translated to positive x position
            /// and when _bodyCtrl value is 1 this widget will 60% out of the media
            /// query
            /// Also the same is with y poisition, initially value is 0 and when _bodyCtrl
            /// value is 1 it will be translated to 32px down
            MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value,
            128 * _bodyCtrl.value,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              boxShadow: [
                BoxShadow(
                  offset: Offset(-16 * _bodyCtrl.value, 0),
                  blurRadius: 64 * _bodyCtrl.value,
                  color: Colors.orange.withOpacity(0.25),
                ),
              ],
              borderRadius: BorderRadius.circular(64 * _bodyCtrl.value),
            ),
          ),
        ),
      ),
    );
  }
}

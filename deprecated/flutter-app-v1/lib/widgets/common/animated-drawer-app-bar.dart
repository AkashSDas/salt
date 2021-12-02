import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/user.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 8),
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

  Widget _buildPlaceholderBtn(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: DesignSystem.grey3,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(_user.user?.profilePicURL ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

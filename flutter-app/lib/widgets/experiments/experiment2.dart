import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
import 'package:salt/widgets/recipes/recipes-list.dart';

/// Simple drawer (flutter drawer) and scaffold body
/// Here body is translated on the right side with animation
/// on the border and boxshadow when the drawer is opened on top of it
/// and when drawer is closed the body comes to normal state (border
/// radius is 0 and no boxshadow and translated to position x == 0)

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double appBarHeight = 64;
  final scaffoldKey;
  const CustomAppBar({required this.scaffoldKey, Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
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
    );
  }

  Widget _buildDrawerBtn(BuildContext context) => IconButton(
        icon: AspectRatio(
          aspectRatio: 1,
          child: FlareActor(
            'assets/flare/icons/filter.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'idle',
          ),
        ),
        color: Colors.black,
        onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
      );

  Widget _buildPlaceholderBtn(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.transparent,
        onPressed: () {},
      );
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.purple),
      child: Container(
        /// App bar width will 60% media query
        width: MediaQuery.of(context).size.width * 0.6,

        child: Drawer(
          elevation: 0,
          child: ListView(
            children: [],
          ),
        ),
      ),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with SingleTickerProviderStateMixin {
  /// Using a GlobalKey for the Custom Drawer to work
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),

        /// Drawer scrim color as transparent
        drawerScrimColor: Colors.transparent,
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            _ctrl.forward();
          } else {
            _ctrl.reverse();
          }
        },
        drawer: AppDrawer(),
        body: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => Transform.translate(
            offset: Offset(
              MediaQuery.of(context).size.width * 0.7 * _ctrl.value,
              64 * _ctrl.value,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-8 * _ctrl.value, 0),
                    blurRadius: 64 * _ctrl.value,
                    color: Colors.orange,
                  ),
                ],
                borderRadius: BorderRadius.circular(64 * _ctrl.value),
              ),
              // child: ListView(
              //   clipBehavior: Clip.none,
              //   children: [
              //     CategoriesList(),
              //     SizedBox(height: 32),
              //     RecipesList(),
              //   ],
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

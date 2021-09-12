import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
import 'package:salt/widgets/recipes/recipes-list.dart';

/// Simple drawer (flutter drawer) and scaffold body
/// Here body is not translated and drawer open on top of it
/// and close normally

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

class _ScreenState extends State<Screen> {
  /// Using a GlobalKey for the Custom Drawer to work
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),

        /// Drawer scrim color as transparent
        drawerScrimColor: Colors.transparent,
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              CategoriesList(),
              SizedBox(height: 32),
              RecipesList(),
            ],
          ),
        ),
      ),
    );
  }
}

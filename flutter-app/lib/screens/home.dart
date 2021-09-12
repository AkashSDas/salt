import 'package:flutter/material.dart';
import 'package:salt/widgets/common/animated-drawer-app-bar.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
import 'package:salt/widgets/recipes/recipes-list.dart';

/// See experiment3.dart in widget to understand the
/// working of appbar and drawer

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isDrawerOpen = false;
  late AnimationController _drawerCtrl;
  late AnimationController _bodyCtrl;
  int animationDuration = 200;
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
          -MediaQuery.of(context).size.width * 0.5 * _drawerCtrl.value,
          0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  /// TODO: When drawer is opened no widget in this widget should be react to any click
  /// except for closing the drawer
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
            MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value,
            128 * _bodyCtrl.value,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 16 + 16 * _bodyCtrl.value,
              horizontal: 16 + 8 * _bodyCtrl.value,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(-16 * _bodyCtrl.value, 0),
                  blurRadius: 64 * _bodyCtrl.value,
                  color: Colors.orange.withOpacity(0.25),
                ),
              ],
              borderRadius: BorderRadius.circular(64 * _bodyCtrl.value),
            ),
            child: _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CategoriesList(),
        SizedBox(height: 32),
        RecipesList(),
      ],
    );
  }
}

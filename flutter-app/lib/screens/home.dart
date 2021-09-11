import 'package:flutter/material.dart';
import 'package:salt/widgets/common/app-bar.dart';
import 'package:salt/widgets/common/drawer.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
import 'package:salt/widgets/recipes/recipes-list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Using a GlobalKey for the Custom Drawer to work
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
        drawer: AppDrawer(),
        drawerScrimColor: Colors.transparent,
        onDrawerChanged: (isOpened) {
          setState(() {
            _isDrawerOpen = isOpened ? true : false;
          });
        },
        body: Container(
          child: Transform.translate(
            offset: _isDrawerOpen
                ? Offset(MediaQuery.of(context).size.width * 0.59 + 32, 32)
                : Offset(0, 0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_isDrawerOpen ? 32 : 0),
                color: Theme.of(context).primaryColor,
                boxShadow: _isDrawerOpen
                    ? [
                        BoxShadow(
                          offset: Offset(-8, 0),
                          blurRadius: 32,
                          color: Color(0xffFFAE63).withOpacity(0.18),
                        ),
                      ]
                    : null,
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CategoriesList(),
                  SizedBox(height: 16),
                  RecipesList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

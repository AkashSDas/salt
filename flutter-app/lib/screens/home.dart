import 'package:flutter/material.dart';
import 'package:salt/widgets/common/app-bar.dart';
import 'package:salt/widgets/common/drawer.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';

class HomeScreen extends StatelessWidget {
  /// Using a GlobalKey for the Custom Drawer to work
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
        drawer: AppDrawer(),
        drawerScrimColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CategoriesList(),
            ],
          ),
        ),
      ),
    );
  }
}

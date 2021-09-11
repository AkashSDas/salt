import 'package:flutter/material.dart';
import 'package:salt/widgets/common/app-bar.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(),
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

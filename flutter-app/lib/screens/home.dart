import 'package:flutter/material.dart';
import 'package:salt/widgets/categories/categories-list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: Text('Auth'),
              ),
              CategoriesList(),
            ],
          ),
        ),
      ),
    );
  }
}

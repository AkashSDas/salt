import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: Text('Auth'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

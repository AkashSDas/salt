import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.59,
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

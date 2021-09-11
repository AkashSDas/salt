import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(64),
        bottomRight: Radius.circular(64),
      ),
      child: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).accentColor),
        child: Drawer(
          elevation: 4,
          child: ListView(
            children: [
              _buildAvatar(context),
              _buildDrawerList(context),
            ],
          ),
        ),
      ),
    );
  }

  /// BUILDER FUNCTIONS
  Widget _buildAvatar(BuildContext context) => Container(
        child: DrawerHeader(
          curve: Curves.easeInOut,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            // backgroundImage: NetworkImage(user?.photoURL ?? userDefaultImg),
          ),
        ),
      );

  Widget _buildDrawerList(BuildContext context) {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}

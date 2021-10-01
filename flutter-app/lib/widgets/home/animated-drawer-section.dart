import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/animated-drawer/drawer-list-item.dart';
import 'package:salt/widgets/home/animated-drawer-item.dart';

class AnimatedDrawerSection extends StatelessWidget {
  final List<DrawerListItem> items;

  const AnimatedDrawerSection({
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return Column(
      children: List.generate(items.length, (index) {
        DrawerListItem item = items[index];

        if (item.authCheck == null)
          return AnimatedDrawerItem(
            flareAssetPath: item.flareAssetPath,
            title: item.title,
            onTap: item.onTap,
          );

        if (item.displayOnAuth! && _user.user != null)
          return AnimatedDrawerItem(
            flareAssetPath: item.flareAssetPath,
            title: item.title,
            onTap: item.onTap,
          );

        if (item.displayOnAuth! == false && _user.user == null)
          return AnimatedDrawerItem(
            flareAssetPath: item.flareAssetPath,
            title: item.title,
            onTap: item.onTap,
          );

        return SizedBox();
      }),
    );
  }
}

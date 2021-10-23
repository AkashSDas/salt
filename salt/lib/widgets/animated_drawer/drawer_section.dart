import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/animated_drawer.dart';
import 'package:salt/widgets/animated_drawer/drawer_item.dart';

class AnimatedDrawerSection extends StatelessWidget {
  final List<AnimatedDrawerListItem> sectionData;

  const AnimatedDrawerSection({
    required this.sectionData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return Column(
      children: List.generate(
        sectionData.length,
        (idx) {
          var item = sectionData[idx];

          if (!item.authCheck) {
            /// If there is no auth check
            return AnimatedDrawerItem(
              iconPath: item.flareIconAssetPath(),
              title: item.title,
              onTap: item.onTap,
              key: Key(item.iconName), // since icon name is going to be unique
            );
          } else if (item.displayOnAuth && _user.token != null) {
            /// display when user is authenticated
            return AnimatedDrawerItem(
              iconPath: item.flareIconAssetPath(),
              title: item.title,
              onTap: item.onTap,
              key: Key(item.iconName), // since icon name is going to be unique
            );
          } else if (!item.displayOnAuth && _user.token == null) {
            /// display when user is not authenticated
            return AnimatedDrawerItem(
              iconPath: item.flareIconAssetPath(),
              title: item.title,
              onTap: item.onTap,
              key: Key(item.iconName), // since icon name is going to be unique
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

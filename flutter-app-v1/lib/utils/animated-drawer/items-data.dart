import 'package:flutter/material.dart';
import 'package:salt/utils/animated-drawer/drawer-list-item.dart';

String getFlareAssetPath(String iconName) {
  return 'assets/flare/icons/static/$iconName.flr';
}

/// Order here is in which they will be rendered
List<DrawerListItem> getAnimatedDrawerItemsData(
  BuildContext context,
  int sectionNumber,
) {
  if (sectionNumber == 1) {
    return [
      DrawerListItem(
        title: 'Home',
        flareAssetPath: getFlareAssetPath('home'),
        onTap: () => Navigator.pushNamed(context, '/home'),
      ),
      DrawerListItem(
        title: 'Recipes',
        flareAssetPath: getFlareAssetPath('search'),
        onTap: () => Navigator.pushNamed(context, '/recipes'),
      ),
      DrawerListItem(
        title: 'Shop',
        flareAssetPath: getFlareAssetPath('bag'),
      ),
      DrawerListItem(
        title: 'Blog',
        flareAssetPath: getFlareAssetPath('document'),
        onTap: () => Navigator.pushNamed(context, '/blog-posts'),
      ),
      DrawerListItem(
        title: 'Learn',
        flareAssetPath: getFlareAssetPath('video-camera'),
      ),
    ];
  }

  if (sectionNumber == 2) {
    return [
      DrawerListItem(
        title: 'Settings',
        flareAssetPath: getFlareAssetPath('cog'),
        onTap: () => Navigator.pushNamed(context, '/settings'),
        authCheck: true,
        displayOnAuth: true,
      ),
      DrawerListItem(
        title: 'About',
        flareAssetPath: getFlareAssetPath('danger-circle'),
      ),
      DrawerListItem(
        title: 'Bookmarks',
        flareAssetPath: getFlareAssetPath('saved'),
        authCheck: true,
        displayOnAuth: true,
      ),
      DrawerListItem(
        title: 'Favourites',
        flareAssetPath: getFlareAssetPath('star'),
        authCheck: true,
        displayOnAuth: true,
      ),
      DrawerListItem(
        title: 'Orders',
        flareAssetPath: getFlareAssetPath('cart'),
        authCheck: true,
        displayOnAuth: true,
      ),
    ];
  }

  return [];
}

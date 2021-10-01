class DrawerListItem {
  final String title;
  final String flareAssetPath;
  void Function()? onTap;

  /// Both properties should be given together, if you want to have auth check
  /// on an item
  final bool? authCheck;
  final bool? displayOnAuth; // display when user is authenticated

  DrawerListItem({
    required this.title,
    required this.flareAssetPath,
    this.onTap,
    this.authCheck,
    this.displayOnAuth,
  });
}

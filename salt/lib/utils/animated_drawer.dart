class AnimatedDrawerListItem {
  final String title;
  final String iconName;
  final void Function()? onTap;

  /// Both properties should be given together, if you want to have auth check
  /// on an item
  final bool authCheck; // check for auth
  final bool displayOnAuth; // display when user is authenticated

  AnimatedDrawerListItem({
    required this.title,
    required this.iconName,
    this.onTap,
    this.authCheck = false,
    this.displayOnAuth = false,
  });

  String flareIconAssetPath() => 'assets/flare-icons/$iconName.flr';
}

var drawerSection1 = [
  AnimatedDrawerListItem(title: 'Home', iconName: 'home'),
  AnimatedDrawerListItem(title: 'Posts', iconName: 'document'),
  AnimatedDrawerListItem(title: 'Recipes', iconName: 'search'),
  AnimatedDrawerListItem(title: 'Shop', iconName: 'bag'),
];

var drawerSection2 = [
  AnimatedDrawerListItem(
    title: 'Settings',
    iconName: 'setting',
    authCheck: true,
    displayOnAuth: true,
  ),
  AnimatedDrawerListItem(
    title: 'Orders',
    iconName: 'buy',
    authCheck: true,
    displayOnAuth: true,
  ),
  AnimatedDrawerListItem(title: 'About', iconName: 'danger-circle'),
  AnimatedDrawerListItem(
    title: 'Login',
    iconName: 'profile',
    authCheck: true,
    displayOnAuth: false,
  ),
];

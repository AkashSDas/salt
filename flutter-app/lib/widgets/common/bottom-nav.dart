import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:salt/designs/designs.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({Key? key}) : super(key: key);

  @override
  _AppBottomNavState createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav>
    with SingleTickerProviderStateMixin {
  late int currentIdx;
  late String animationState;

  @override
  void initState() {
    super.initState();
    currentIdx = 0;
    animationState = 'idle';
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      /// use the scaffoldKey or some state to know when the AnimatedDrawer (used in home screen)
      /// is opened and according to that translate the bottom nav with some animation
      /// to keep the animation in sync. Here no animation is done and also translation of bottom
      /// nav is done.
      offset: Offset(0, 0),
      child: Container(
        /// Wrapping bottom nav with Theme to change bg color of bottom nav
        /// Stackoverflow post for the solution  is below
        /// https://stackoverflow.com/questions/49307858/style-bottomnavigationbar-in-flutter#:~:text=There%20is%20no%20option%20to,new%20Theme(%20data%3A%20Theme.
        child: Theme(
          /// The default color looks great so not changing the color
          /// but if you want to then uncomment and change the canvasColor
          data: Theme.of(context).copyWith(
              // canvasColor: DesignSystem.grey1,
              ),
          child: BottomNavigationBar(
            items: _navItems(),
            onTap: (int idx) {
              _onTap(idx, context);
            },

            /// Icon themes won't work since using Flare
            // unselectedIconTheme: DesignSystem.appBarUnselectedIconTheme,
            // selectedIconTheme: DesignSystem.appBarSelectedIconTheme,

            selectedItemColor: DesignSystem.appBarSelectedItemColor,
            unselectedItemColor: DesignSystem.appBarUnselectedItemColor,
            showUnselectedLabels: true,
            currentIndex: currentIdx,
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _navItems() => [
        _buildBottomNavItem(flareAssetName: 'home', label: 'Home', idx: 0),
        _buildBottomNavItem(flareAssetName: 'search', label: 'Recipes', idx: 1),
        _buildBottomNavItem(flareAssetName: 'bag', label: 'Shop', idx: 2),
        _buildBottomNavItem(flareAssetName: 'document', label: 'Blog', idx: 3),
        _buildBottomNavItem(
          flareAssetName: 'video-camera',
          label: 'Learn',
          idx: 4,
        ),
      ];

  BottomNavigationBarItem _buildBottomNavItem({
    required String flareAssetName,
    required String label,
    required int idx,
  }) =>
      BottomNavigationBarItem(
        icon: Container(
          height: 24,
          width: 24,
          child: AspectRatio(
            aspectRatio: 1,
            child: FlareActor(
              'assets/flare/icons/active/$flareAssetName.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: idx == currentIdx ? 'active' : 'idle',

              /// The color is not updating properly (it sometimes does (when
              /// the application starts and you immediately click on nav item)
              /// and the other times it doesn't update). Note the currentIdx
              /// is updating correctly
              /// 
              /// Note: Don't give color property any value if you want to animate
              /// or change color dynamically
              /// 
              // color:
              //     currentIdx == idx ? DesignSystem.orange : DesignSystem.grey3,
              // color: DesignSystem.grey3,
            ),
          ),
        ),
        label: label,
      );

  void _onTap(int idx, BuildContext context) async {
    switch (idx) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }
}

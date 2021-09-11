import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 64;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({required this.scaffoldKey, Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  /// This reponsive app bar solution
  /// The outer Container is aligned at the bottomCenter which is the
  /// part from status bar so that the inner Container the part that
  /// is below the status bar is visible. The items for app bar should
  /// be added in the inner Container and styling for the app bar
  /// should be done in outer Container but then this app bar implementation
  /// is very flexible.
  ///
  /// The appBarHeight is the height of the inner Container i.e. the
  /// part below the status bar
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          // BoxShadow(
          //   offset: Offset(4, 4),
          //   color: Colors.black.withOpacity(0.25),
          //   blurRadius: 8,
          // ),
        ],
      ),
      child: Container(
        /// Having the height infinite will take the entire space
        /// i.e. also cover the outer Container which has the status
        /// bar part and what will do is that alignement now will
        /// be according to the status bar part + container of height
        /// appBarHeight which not good because the app bar we want to use
        /// is the part below the status bar that's why instead of using
        /// height as double.infinity I've used appBarHeight
        // height: double.infinity,
        height: appBarHeight,
        // width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildDrawerBtn(context), _buildPlaceholderBtn(context)],
        ),
      ),
    );
  }

  Widget _buildDrawerBtn(BuildContext context) => IconButton(
        icon: AspectRatio(
          aspectRatio: 1,
          child: FlareActor(
            'assets/flare/icons/filter.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'idle',
          ),
        ),
        color: Colors.black,
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      );

  Widget _buildPlaceholderBtn(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.transparent,
        onPressed: () {},
      );
}

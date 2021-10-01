import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/utils/animated-drawer/items-data.dart';
import 'package:salt/widgets/blog-post/blog-post-list.dart';
import 'package:salt/widgets/common/animated-drawer-app-bar.dart';
import 'package:salt/widgets/common/bottom-nav.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
import 'package:salt/widgets/home/animated-drawer-section.dart';
import 'package:salt/widgets/home/auth-check.dart';
import 'package:salt/widgets/home/body.dart';
import 'package:salt/widgets/home/user-info.dart';
import 'package:salt/widgets/home/user-profile-pic.dart';
import 'package:salt/widgets/recipes/recipes-list.dart';

/// See experiment3.dart in widget to understand the
/// working of appbar and drawer

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isDrawerOpen = false;
  late AnimationController _drawerCtrl;
  late AnimationController _bodyCtrl;
  int animationDuration = 200;
  final double appBarHeight = 64;

  void toggleDrawerState() => setState(() => isDrawerOpen != isDrawerOpen);

  late Future<dynamic> _isAuthenticated;

  @override
  void initState() {
    super.initState();

    _drawerCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
      value: 1,
    );

    _bodyCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
      value: 0,
    );

    _isAuthenticated = isAuthenticated();
  }

  // Future<void> _authenticate() async {
  //   var respone = await isAuthenticated();
  //   if (respone == null)
  // }

  @override
  Widget build(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(
          isDrawerOpen: isDrawerOpen,
          drawerCtrl: _drawerCtrl,
          bodyCtrl: _bodyCtrl,
          toggleDrawerState: toggleDrawerState,
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: 0),
        body: FutureBuilder(
          future: _isAuthenticated,
          builder: (context, snapshot) {
            /// Updating
            // if (snapshot.hasData &&
            //     snapshot.data != null &&
            //     _user.user == null) {
            //   _user.login(snapshot.data);
            // }

            return Stack(
              children: [
                _buildDrawer(context),
                _buildBody(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return AnimatedBuilder(
      animation: _drawerCtrl,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          -MediaQuery.of(context).size.width * 0.5 * _drawerCtrl.value,
          0,
        ),
        child: AnimatedDrawer(),
      ),
    );
  }

  /// TODO: When drawer is opened no widget in this widget should be react to any click
  /// except for closing the drawer
  Widget _buildBody(BuildContext context) {
    return AnimatedBuilder(
      animation: _bodyCtrl,
      builder: (context, child) => GestureDetector(
        onTap: () {
          if (isDrawerOpen) {
            setState(() {
              isDrawerOpen = !isDrawerOpen;
            });
          }
          _drawerCtrl.forward();
          _bodyCtrl.reverse();
        },
        child: Transform.translate(
          offset: Offset(
            MediaQuery.of(context).size.width * 0.6 * _bodyCtrl.value,
            128 * _bodyCtrl.value,
          ),
          child: Container(
            /// Adding clip behavior here to avoid SingleChildScrollView of _Body widget to
            /// to scroll the content and make it visible above the AppBar region as SingleChildScrollView's
            /// clipBehavior is set to Clip.none to avoid shadow clipping of internal widgets like
            /// BlogPostList
            clipBehavior: Clip.antiAlias,

            padding: EdgeInsets.symmetric(
              vertical: 16 + 16 * _bodyCtrl.value,
              horizontal: 16 + 8 * _bodyCtrl.value,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(-16 * _bodyCtrl.value, 0),
                  blurRadius: 64 * _bodyCtrl.value,
                  color: Colors.orange.withOpacity(0.25),
                ),
              ],
              borderRadius: BorderRadius.circular(64 * _bodyCtrl.value),
            ),
            child: Body(),
          ),
        ),
      ),
    );
  }
}

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({Key? key}) : super(key: key);

  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
  Widget _buildSpace(double space) => AuthCheck(child: SizedBox(height: space));
  List<Widget> _buildUserInfo() => [
        UserName(),
        _buildSpace(8),
        UserEmailAddress(),
      ];

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          UserProfilePic(),
          _buildSpace(16),
          ..._buildUserInfo(),
          _buildSpace(16),

          AnimatedDrawerSection(items: getAnimatedDrawerItemsData(context, 1)),
          SizedBox(height: 16),
          AnimatedDrawerSection(items: getAnimatedDrawerItemsData(context, 2)),

          SizedBox(height: 16),

          // _user.user == null
          //     ? _buildDrawerItem(
          //         context,
          //         _getFlareAssetPath('user'),
          //         'Login',
          //         () => Navigator.pushNamed(context, '/auth'),
          //       )
          //     : SizedBox(),

          /// The last item will also have sizedbox of heigh 16
          /// so calculate distance accordingly
          _user.user == null ? SizedBox(height: 16) : SizedBox(),

          _user.user == null
              ? TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).accentColor,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/auth'),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sofia Pro',
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 15,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

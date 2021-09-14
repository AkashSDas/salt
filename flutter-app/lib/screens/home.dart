import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/widgets/common/animated-drawer-app-bar.dart';
import 'package:salt/widgets/common/bottom-nav.dart';
import 'package:salt/widgets/food-categories/categories-list.dart';
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

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return Consumer<UserProvider>(
      builder: (context, data, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: CustomAppBar(
            isDrawerOpen: isDrawerOpen,
            drawerCtrl: _drawerCtrl,
            bodyCtrl: _bodyCtrl,
            toggleDrawerState: toggleDrawerState,
          ),
          bottomNavigationBar: AppBottomNav(),
          body: FutureBuilder(
            future: _isAuthenticated.then((value) {
              /// updating the user provider here is a right way to do it and not to do
              /// it inside the builder like
              /// if (snapshot.hasData) {
              ///     _user.login(snapshot.data);
              /// }
              /// The above way is not right (it causes error below)
              ///
              /// Error -
              /// Widget cannot be marked as needing to build because the framework
              /// is already in the process of building widgets
              ///
              /// Detail explaination is on below post
              /// https://stackoverflow.com/questions/60852896/widget-cannot-be-marked-as-needing-to-build-because-the-framework-is-already-in
              ///
              /// Now using the solution given in the above post didn't worked, I've to use _user
              /// defined in this build function (can also be defined in the class level) and then
              /// it worked perfectly without causing any error.
              /// In the below 2 methods didn't worked
              ///
              /// 1.
              /// future: _isAuthentication.then((value) {
              ///   if (value != null) {
              ///     Provider.of<UserProvider>(context, listen: false).login(value));
              ///   }
              /// })
              ///
              /// 2.
              /// future: _isAuthentication.then((value) {
              ///   if (value != null) {
              ///     Provider.of<UserProvider>(context, listen: false).user = value['user']);
              ///     Provider.of<UserProvider>(context, listen: false).token = value['token']);
              ///   }
              /// })

              if (value != null) _user.login(value);
            }),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  _buildDrawer(context),
                  _buildBody(context),
                ],
              );
            },
          ),
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
            child: _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CategoriesList(),
        SizedBox(height: 32),
        RecipesList(),
      ],
    );
  }
}

class DrawerListItem {
  final String title;
  final String flareAssetPath;
  void Function()? onTap;

  DrawerListItem(
      {required this.title, required this.flareAssetPath, this.onTap});
}

class AnimatedDrawer extends StatefulWidget {
  const AnimatedDrawer({Key? key}) : super(key: key);

  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> {
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
          Container(
            width: 115,
            height: 115,
            decoration: BoxDecoration(
              color: DesignSystem.grey1,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  _user.user != null ? _user.user!.profilePicURL : '',
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _user.user != null ? _user.user!.username : 'No name',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
          ),
          SizedBox(height: 8),
          Text(
            _user.user != null ? _user.user!.email : 'No email',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
          SizedBox(height: 32),

          /// Items section 1
          ...[
            DrawerListItem(
              title: 'Home',
              flareAssetPath: _getFlareAssetPath('home'),
            ),
            DrawerListItem(
              title: 'Recipes',
              flareAssetPath: _getFlareAssetPath('search'),
            ),
            DrawerListItem(
              title: 'Shop',
              flareAssetPath: _getFlareAssetPath('bag'),
            ),
            DrawerListItem(
              title: 'Blog',
              flareAssetPath: _getFlareAssetPath('document'),
            ),
            DrawerListItem(
              title: 'Learn',
              flareAssetPath: _getFlareAssetPath('video-camera'),
            ),
          ].map(
            (item) => Column(
              children: [
                _buildDrawerItem(
                  context,
                  item.flareAssetPath,
                  item.title,
                  item.onTap,
                ),

                /// The last item will also have sizedbox of heigh 16
                /// so calculate distance accordingly
                SizedBox(height: 16),
              ],
            ),
          ),

          SizedBox(height: 32),

          /// Items section 2
          ...[
            DrawerListItem(
              title: 'Settings',
              flareAssetPath: _getFlareAssetPath('cog'),
            ),
            DrawerListItem(
              title: 'About',
              flareAssetPath: _getFlareAssetPath('danger-circle'),
            ),
            DrawerListItem(
              title: 'Bookmarks',
              flareAssetPath: _getFlareAssetPath('saved'),
            ),
            DrawerListItem(
              title: 'Favourites',
              flareAssetPath: _getFlareAssetPath('star'),
            ),
            DrawerListItem(
              title: 'Orders',
              flareAssetPath: _getFlareAssetPath('cart'),
            ),
          ].map(
            (item) => Column(
              children: [
                _buildDrawerItem(
                  context,
                  item.flareAssetPath,
                  item.title,
                  item.onTap,
                ),

                /// The last item will also have sizedbox of heigh 16
                /// so calculate distance accordingly
                SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getFlareAssetPath(String iconName) =>
      'assets/flare/icons/static/$iconName.flr';

  Widget _buildDrawerItem(
    BuildContext context,
    String flareAssetPath,
    String title,
    void Function()? onTap,
  ) =>
      InkWell(
        onTap: onTap != null ? onTap : () {},
        child: Container(
          height: 24,
          child: ListTile(
            leading: AspectRatio(
              aspectRatio: 1,
              child: FlareActor(
                flareAssetPath,
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: 'idle',
                color: DesignSystem.grey3,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: DesignSystem.grey3,
                fontFamily: DesignSystem.fontBody,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            horizontalTitleGap: 16,
            minLeadingWidth: 24,
          ),
        ),
      );
}

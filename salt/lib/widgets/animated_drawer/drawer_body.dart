import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/animated_drawer.dart';
import 'package:salt/widgets/animated_drawer/drawer_logo.dart';
import 'package:salt/widgets/auth/auth_check.dart';
import 'package:salt/widgets/buttons/index.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /// width of the drawer
      width: MediaQuery.of(context).size.width * 0.5,

      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          const _UserProfilePic(),
          const SizedBox(height: 16),
          _AnimatedDrawerSection(sectionData: drawerSection1),
          const SizedBox(height: 16),
          _AnimatedDrawerSection(sectionData: drawerSection2),
          const AuthCheck(displayOnAuth: false, child: SizedBox(height: 16)),
          AuthCheck(
            displayOnAuth: false,
            child: RoundedCornerButton(
              text: 'Sign up',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _UserProfilePic extends StatelessWidget {
  const _UserProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    /// User profile pic
    if (_user.token != null && _user.user != null) {
      return Container(
        width: 115,
        height: 115,
        decoration: BoxDecoration(
          color: Theme.of(context).iconTheme.color,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(_user.user!.profilePicURL),
          ),
        ),
      );
    }

    /// Logo
    return const DrawerLogo();
  }
}

class _AnimatedDrawerSection extends StatelessWidget {
  final List<AnimatedDrawerListItem> sectionData;

  const _AnimatedDrawerSection({
    required this.sectionData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider _user = Provider.of<UserProvider>(context);

    return Column(
      children: [
        ...List.generate(
          sectionData.length,
          (idx) {
            var item = sectionData[idx];

            if (!item.authCheck) {
              /// If there is no auth check
              return _AnimatedDrawerItem(
                iconPath: item.flareIconAssetPath(),
                title: item.title,
                onTap: item.onTap,
                key:
                    Key(item.iconName), // since icon name is going to be unique
              );
            } else if (item.displayOnAuth && _user.token != null) {
              /// display when user is authenticated
              return _AnimatedDrawerItem(
                iconPath: item.flareIconAssetPath(),
                title: item.title,
                onTap: item.onTap,
                key:
                    Key(item.iconName), // since icon name is going to be unique
              );
            } else if (!item.displayOnAuth && _user.token == null) {
              /// display when user is not authenticated
              return _AnimatedDrawerItem(
                iconPath: item.flareIconAssetPath(),
                title: item.title,
                onTap: item.onTap,
                key:
                    Key(item.iconName), // since icon name is going to be unique
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}

class _AnimatedDrawerItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final void Function()? onTap;

  const _AnimatedDrawerItem({
    required this.iconPath,
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Container(
          height: 44,

          /// While testing the app in development in mobile phone
          /// whithout the color property if i clicked on side of the text i.e. this container
          /// and not on text or icon then nothing happens i.e. onTap of GestureDetector is
          /// not triggered, but once i give color (it takes the entire width, which i think
          /// it didn't took without color property) it onTap of GestureDetector is triggered
          /// when i clicked on side of the text. Having width: double.infinity didn't worked
          /// either and i didn't tried with fixed width
          color: Colors.transparent,

          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Builder(builder: (context) {
      return SizedBox(
        width: 24,
        height: 24,
        child: AspectRatio(
          aspectRatio: 1,
          child: FlareActor(
            iconPath,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'idle',
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Builder(builder: (context) {
      return Text(
        title,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontFamily: DesignSystem.fontBody,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/widgets/animations/reveal.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/display_on_auth.dart';
import 'package:salt/widgets/common/divider.dart';
import 'package:salt/widgets/drawer/animate_appbar_on_scroll.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimateAppBarOnScroll(
      bottomNavIdx: 4,
      children: [
        RevealAnimation(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Account', style: DesignSystem.heading1),
          ),
          startAngle: 10,
          startYOffset: 100,
          delay: 100,
          duration: 1000,
          curve: Curves.easeOut,
        ),
        DesignSystem.spaceH20,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DashedSeparator(height: 1.6),
        ),
        DesignSystem.spaceH20,
        AnimationLimiter(
          child: Column(
            children: [
              DisplayOnAuth(child: _buildLogoutBtn(context)),
              DesignSystem.spaceH20,
              DisplayOnNoAuth(
                child: PrimaryButton(
                  text: 'Signup',
                  onPressed: () => Navigator.pushNamed(context, '/auth/signup'),
                  horizontalPadding: 100,
                ),
              ),
              DesignSystem.spaceH20,
              DisplayOnNoAuth(
                child: SecondaryButton(
                  text: 'Login',
                  onPressed: () => Navigator.pushNamed(context, '/auth/login'),
                  horizontalPadding: 100,
                  verticalPadding: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    final _user = Provider.of<UserProvider>(context);

    return SecondaryButton(
      text: 'Logout',
      horizontalPadding: 100,
      verticalPadding: 16,
      onPressed: () async {
        final _service = AuthService();
        await _service.logout();
        _user.logout();
        successSnackBar(context: context, msg: 'Successfully logged out');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          ModalRoute.withName('/'),
        );
      },
    );
  }
}

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimatedDrawer(child: _SignupBody());
  }
}

/// Signup Body

class _SignupBody extends StatefulWidget {
  const _SignupBody({Key? key}) : super(key: key);

  @override
  __SignupBodyState createState() => __SignupBodyState();
}

class __SignupBodyState extends State<_SignupBody> {
  var animation = 'idle';

  void updateAnimation(String value) {
    setState(() {
      animation = value;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<AnimatedDrawerProvider>(
        context,
        listen: false,
      ).animateAppBar(64);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          width: 150,
          child: FlareActor(
            'assets/flare/other-emojis/glasses.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: animation,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

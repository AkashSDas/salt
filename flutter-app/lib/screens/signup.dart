import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/signup_form.dart';
import 'package:salt/validators.dart';
import 'package:salt/widgets/common/form.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';

import '../design_system.dart';

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
  final validator = SignUpFormValidators();

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
    return ChangeNotifierProvider(
      create: (context) => SignupFormProvider(),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Builder(
              builder: (context) {
                final _p = Provider.of<SignupFormProvider>(context);
                return FlareActor(
                  'assets/flare/other-emojis/glasses.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: _p.animation,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _UsernameInputField(validator: validator.username),
          const SizedBox(height: 20),
          _EmailInputField(validator: validator.email),
          const SizedBox(height: 20),
          _PasswordInputField(validator: validator.password),
        ],
      ),
    );
  }
}

class _UsernameInputField extends StatelessWidget {
  final MultiValidator validator;

  const _UsernameInputField({
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<SignupFormProvider>(context);
    return IconFormInput(
      prefixIcon: const Icon(IconlyLight.profile, color: DesignSystem.icon),
      label: 'Username',
      onChanged: (value) {
        _provider.updateAnimation(validator.isValid(value));
        _provider.updateStringFormValue('username', value);
      },
      hintText: 'John Simth',
      validator: validator,
    );
  }
}

class _EmailInputField extends StatelessWidget {
  final MultiValidator validator;

  const _EmailInputField({
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<SignupFormProvider>(context);
    return IconFormInput(
      prefixIcon: const Icon(IconlyLight.message, color: DesignSystem.icon),
      label: 'Email',
      onChanged: (value) => _provider.updateStringFormValue('email', value),
      hintText: 'john@gmail.com',
      validator: validator,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordInputField extends StatefulWidget {
  final MultiValidator validator;

  const _PasswordInputField({
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<_PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<_PasswordInputField> {
  var showPassword = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<SignupFormProvider>(context);
    return IconFormInput(
      prefixIcon: const Icon(IconlyLight.lock, color: DesignSystem.icon),
      suffixIcon: InkWell(
        onTap: () => setState(() => showPassword = !showPassword),
        child: showPassword
            ? const Icon(IconlyLight.hide, color: DesignSystem.icon)
            : const Icon(IconlyLight.show, color: DesignSystem.icon),
      ),
      label: 'Password',
      onChanged: (value) => _provider.updateStringFormValue('password', value),
      hintText: 'Secure password',
      validator: widget.validator,
      obscureText: showPassword ? false : true,
    );
  }
}

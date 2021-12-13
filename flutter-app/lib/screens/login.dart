import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/animated_drawer.dart';
import 'package:salt/providers/login_form.dart';
import 'package:salt/providers/user_provider.dart';
import 'package:salt/widgets/common/alert.dart';
import 'package:salt/widgets/common/buttons.dart';
import 'package:salt/widgets/common/form.dart';
import 'package:salt/widgets/drawer/animated_drawer.dart';

import '../design_system.dart';
import '../validators.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimatedDrawer(child: _LoginBody());
  }
}

/// Login Body

class _LoginBody extends StatefulWidget {
  const _LoginBody({Key? key}) : super(key: key);

  @override
  __LoginBodyState createState() => __LoginBodyState();
}

class __LoginBodyState extends State<_LoginBody> {
  final validator = LoginFormValidators();

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
      create: (context) => LoginFormProvider(),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        physics: const ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: Builder(
              builder: (context) {
                final _p = Provider.of<LoginFormProvider>(context);
                return FlareActor(
                  'assets/flare/other-emojis/glasses.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: _p.animation,
                );
              },
            ),
          ),
          _EmailInputField(validator: validator.email),
          const SizedBox(height: 20),
          _PasswordInputField(validator: validator.password),
          const SizedBox(height: 40),
          const _SubmitBtn(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/auth/singup'),
              child: RichText(
                text: TextSpan(
                    text: "Don't have an ",
                    style: DesignSystem.caption,
                    children: [
                      TextSpan(
                        text: 'account',
                        style: DesignSystem.caption.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                      const TextSpan(text: '?'),
                    ]),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SubmitBtn extends StatelessWidget {
  const _SubmitBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<LoginFormProvider>(context);
    final _user = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: PrimaryButton(
        onPressed: () async {
          if (!_provider.loading) {
            final result = await _provider.signupUser();

            if (result.error) {
              failedSnackBar(context: context, msg: result.msg);
            } else {
              if (result.data != null) _user.login(result.data);
              successSnackBar(context: context, msg: result.msg);
              await Future.delayed(const Duration(seconds: 4));
              await Navigator.popAndPushNamed(context, '/');
            }
          }
        },
        text: _provider.loading ? 'Submitting...' : 'Login',
        verticalPadding: 20,
      ),
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
    final _provider = Provider.of<LoginFormProvider>(context);
    return IconFormInput(
      prefixIcon: const Icon(IconlyLight.message, color: DesignSystem.icon),
      label: 'Email',
      onChanged: (value) {
        _provider.updateAnimation(validator.isValid(value));
        _provider.updateStringFormValue('email', value);
      },
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
    final _provider = Provider.of<LoginFormProvider>(context);
    return IconFormInput(
      prefixIcon: const Icon(IconlyLight.lock, color: DesignSystem.icon),
      suffixIcon: InkWell(
        onTap: () => setState(() => showPassword = !showPassword),
        child: showPassword
            ? const Icon(IconlyLight.hide, color: DesignSystem.icon)
            : const Icon(IconlyLight.show, color: DesignSystem.icon),
      ),
      label: 'Password',
      onChanged: (value) {
        _provider.updateAnimation(widget.validator.isValid(value));
        _provider.updateStringFormValue('password', value);
      },
      hintText: 'Secure password',
      validator: widget.validator,
      obscureText: showPassword ? false : true,
    );
  }
}

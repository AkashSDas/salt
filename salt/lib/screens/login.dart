import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/login.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/auth.dart';
import 'package:salt/widgets/animated_drawer/drawer_logo.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/forms/regular_input_field.dart';

class LoginScreen extends StatelessWidget {
  final _validator = LoginFormValidators();
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginFormProvider(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
          bottom: 32,
        ),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 64),
              child: Center(child: DrawerLogo()),
            ),
            const SizedBox(height: 32),
            Text('Login', style: DesignSystem.heading1),
            const SizedBox(height: 16),
            const Text(
              '👋 Hello, welcome back!',
              style: DesignSystem.bodyIntro,
            ),
            const SizedBox(height: 32),
            _EmailInputField(validator: _validator.email),
            const SizedBox(height: 32),
            _PasswordInputField(validator: _validator.password),
            const SizedBox(height: 32),
            const _SaveBtn(),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/auth/signup'),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DesignSystem.caption,
                  children: [
                    const TextSpan(text: "Don't have an account, "),
                    TextSpan(
                      text: "Sign up",
                      style: DesignSystem.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DesignSystem.dodgerBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveBtn extends StatelessWidget {
  const _SaveBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    UserProvider _user = Provider.of<UserProvider>(context);
    return RoundedCornerButton(
      onPressed: () async {
        if (!_provider.loading) {
          var data = await _provider.loginUser(context);
          if (data != null) _user.login(data);
          Navigator.popAndPushNamed(context, '/');
        }
      },
      text: _provider.loading ? 'Loading...' : 'Login',
      verticalPadding: 16 + 6,
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
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    return RegularInputField(
      label: 'Email',
      onChanged: (value) => _provider.updateFormValue('email', value),
      hintText: 'john@gmail.com',
      validator: validator,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  final MultiValidator validator;

  const _PasswordInputField({
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    return RegularInputField(
      label: 'Password',
      onChanged: (value) => _provider.updateFormValue('password', value),
      hintText: 'Secure password',
      validator: validator,
      obscureText: true,
    );
  }
}

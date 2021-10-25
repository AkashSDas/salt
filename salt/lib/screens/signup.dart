import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/signup.dart';
import 'package:salt/utils/auth.dart';
import 'package:salt/widgets/animated_drawer/drawer_logo.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/forms/regular_input_field.dart';

class SignUpScreen extends StatelessWidget {
  final _validator = SignUpFormValidators();
  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpFormProvider(),
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
            Text('Sign Up', style: DesignSystem.heading1),
            const SizedBox(height: 16),
            const Text(
              '🚀 Let’s get started!',
              style: DesignSystem.bodyIntro,
            ),
            const SizedBox(height: 32),
            _UsernameInputField(validator: _validator.username),
            const SizedBox(height: 32),
            _EmailInputField(validator: _validator.email),
            const SizedBox(height: 32),
            _PasswordInputField(validator: _validator.password),
            const SizedBox(height: 32),
            const _SaveBtn(),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/auth/login'),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DesignSystem.caption,
                  children: [
                    const TextSpan(text: "Already have an account, "),
                    TextSpan(
                      text: "Login",
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
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return RoundedCornerButton(
      onPressed: () async {
        if (!_provider.loading) {
          _provider.signupUser(context);
        }
      },
      text: _provider.loading ? 'Loading...' : 'Sign up',
      verticalPadding: 16 + 6,
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
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return RegularInputField(
      label: 'Username',
      onChanged: (value) => _provider.updateFormValue('username', value),
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
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
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
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return RegularInputField(
      label: 'Password',
      onChanged: (value) => _provider.updateFormValue('password', value),
      hintText: 'Secure password',
      validator: validator,
      obscureText: true,
    );
  }
}

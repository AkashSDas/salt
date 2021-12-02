import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/login.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/form/validators.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/common/snackbar.dart';
import 'package:salt/widgets/form/input.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _validator = LoginFormValidators();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildEmailInputField(context),
            _buildSpace(),
            _buildPasswordInputField(context),
            _buildSpace(),
            _buildLoginBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInputField(BuildContext context) {
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    return FormInputField(
      label: 'Password',
      onChanged: (value) => _provider.updateFormValue('password', value),
      hintText: 'Secure password',
      validator: _validator.password,
      obscureText: true,
    );
  }

  Widget _buildEmailInputField(BuildContext context) {
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    return FormInputField(
      label: 'Email',
      onChanged: (value) => _provider.updateFormValue('email', value),
      hintText: 'john@gmail.com',
      validator: _validator.email,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildSpace() => SizedBox(height: 32);

  Widget _buildLoginBtn(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    return ExpandedButton(
        text: _provider.loading ? 'Loading...' : 'Login',
        verticalPadding: 20,
        onPressed: () async {
          bool checkEmail = _validator.email.isValid(_provider.email);
          bool checkPassword = _validator.password.isValid(_provider.password);

          if (!checkEmail)
            failedSnackBar(context: context, msg: 'Invalid email');
          else if (!checkPassword)
            failedSnackBar(context: context, msg: 'Invalid password');
          else {
            var success = await _provider.userLogin(context);

            /// Logging in the user
            if (success[0] && success[1] != null) {
              _user.login(success[1]);
              await Future.delayed(Duration(seconds: 1));
              Navigator.popAndPushNamed(context, '/home');
            }
          }
        });
  }
}

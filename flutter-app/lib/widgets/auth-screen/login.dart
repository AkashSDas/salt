import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/auth.dart';
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
  Map<String, String> _formData = {'email': '', 'password': ''};

  Future<dynamic> _submit() async {
    bool checkEmail = _validator.email.isValid(_formData['email']);
    bool checkPassword = _validator.password.isValid(_formData['password']);

    if (!checkEmail)
      failedSnackBar(context: context, msg: 'Invalid email');
    else if (!checkPassword)
      failedSnackBar(context: context, msg: 'Invalid password');
    else {
      final response = await login(_formData);

      if (response[1] != null)
        failedSnackBar(
          context: context,
          msg: 'Something went wrong, Please try again',
        );
      else {
        if (response[0]['error'])
          failedSnackBar(context: context, msg: response[0]['message']);
        else {
          /// Login the user
          successSnackBar(context: context, msg: response[0]['message']);
          return response[0]['data'];
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildEmailInputField(),
            _buildSpace(),
            _buildPasswordInputField(),
            _buildSpace(),
            _buildLoginBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInputField() => FormInputField(
        'email',
        'john@gmail.com',
        'Email',
        _validator.email,
        _formData,
        keyboardType: TextInputType.emailAddress,
      );

  Widget _buildPasswordInputField() => FormInputField(
        'password',
        'Secure password',
        'Password',
        _validator.password,
        _formData,
        obscureText: true,
      );

  Widget _buildSpace() => SizedBox(height: 32);

  Widget _buildLoginBtn(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);

    return ExpandedButton(
      text: 'Login',
      verticalPadding: 20,
      onPressed: () async {
        var data = await _submit();
        if (data != null) {
          _user.login(data);
          await Future.delayed(Duration(seconds: 1));
          Navigator.popAndPushNamed(context, '/home');
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/utils/form/validators.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/common/snackbar.dart';
import 'package:salt/widgets/form/input.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _validator = SignUpFormValidators();
  Map<String, String> _formData = {'email': '', 'username': '', 'password': ''};

  /// Submit
  void _submit() async {
    bool checkUsername = _validator.username.isValid(_formData['username']);
    bool checkEmail = _validator.email.isValid(_formData['email']);
    bool checkPassword = _validator.password.isValid(_formData['password']);

    if (!checkUsername)
      failedSnackBar(context: context, msg: 'Invalid username');
    else if (!checkEmail)
      failedSnackBar(context: context, msg: 'Invalid email');
    else if (!checkPassword)
      failedSnackBar(context: context, msg: 'Invalid password');
    else {
      final response = await signup(_formData);

      if (response[1] != null)

        /// Any error in calling
        failedSnackBar(
          context: context,
          msg: 'Something went wrong, Please try again',
        );
      else {
        if (response[0]['error'])
          failedSnackBar(context: context, msg: response[0]['message']);
        else {
          successSnackBar(context: context, msg: response[0]['message']);
          await Future.delayed(Duration(seconds: 3));
          Navigator.popAndPushNamed(context, '/');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildUsernameInputField(),
            _buildSpace(),
            _buildEmailInputField(),
            _buildSpace(),
            _buildPasswordInputField(),
            _buildSpace(),
            _buildSignUpBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return ExpandedButton(
      text: 'Sign up',
      verticalPadding: 20,
      onPressed: () => _submit(),
    );
  }

  Widget _buildSpace() => SizedBox(height: 32);

  Widget _buildUsernameInputField() => FormInputField(
        'username',
        'John Smith',
        'Username',
        _validator.username,
        _formData,
      );

  Widget _buildPasswordInputField() => FormInputField(
        'password',
        'secure password',
        'Password',
        _validator.password,
        _formData,
        obscureText: true,
      );

  Widget _buildEmailInputField() => FormInputField(
        'email',
        'john@gmail.com',
        'Email',
        _validator.email,
        _formData,
        keyboardType: TextInputType.emailAddress,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/signup.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildUsernameInputField(context),
            _buildSpace(),
            _buildEmailInputField(context),
            _buildSpace(),
            _buildPasswordInputField(context),
            _buildSpace(),
            _buildSignUpBtn(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpBtn(BuildContext context) {
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return ExpandedButton(
      text: _provider.loading ? 'Loading...' : 'Sign up',
      verticalPadding: 20,
      onPressed: () async {
        bool checkUsername = _validator.username.isValid(_provider.username);
        bool checkEmail = _validator.email.isValid(_provider.email);
        bool checkPassword = _validator.password.isValid(_provider.password);

        if (!checkUsername)
          failedSnackBar(context: context, msg: 'Invalid username');
        else if (!checkEmail)
          failedSnackBar(context: context, msg: 'Invalid email');
        else if (!checkPassword)
          failedSnackBar(context: context, msg: 'Invalid password');
        else {
          _provider.userSignUp(context);
        }
      },
    );
  }

  Widget _buildSpace() => SizedBox(height: 32);

  Widget _buildUsernameInputField(BuildContext context) {
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return FormInputField(
      label: 'Username',
      onChanged: (value) => _provider.updateFormValue('username', value),
      hintText: 'John Simth',
      validator: _validator.username,
    );
  }

  Widget _buildEmailInputField(BuildContext context) {
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return FormInputField(
      label: 'Email',
      onChanged: (value) => _provider.updateFormValue('email', value),
      hintText: 'john@gmail.com',
      validator: _validator.email,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordInputField(BuildContext context) {
    SignUpFormProvider _provider = Provider.of<SignUpFormProvider>(context);
    return FormInputField(
      label: 'Password',
      onChanged: (value) => _provider.updateFormValue('password', value),
      hintText: 'Secure password',
      validator: _validator.password,
      obscureText: true,
    );
  }
}

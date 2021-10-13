import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/designs/designs.dart';
import 'package:salt/providers/login.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/utils/form/validators.dart';
import 'package:salt/widgets/common/btns.dart';
import 'package:salt/widgets/common/snackbar.dart';

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
    return KFormInputField(
      label: 'Password',
      onChanged: (value) => _provider.updateFormValue('password', value),
      hintText: 'Secure password',
      validator: _validator.password,
      obscureText: true,
    );
  }

  Widget _buildEmailInputField(BuildContext context) {
    LoginFormProvider _provider = Provider.of<LoginFormProvider>(context);
    return KFormInputField(
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

class KFormInputField extends StatelessWidget {
  final String label;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String hintText;

  const KFormInputField({
    required this.label,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  /// WIDGETS ///

  Widget _buildLabel(BuildContext context) {
    var style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        );

    return Container(
      alignment: Alignment.centerLeft,
      child: Text(label, style: style),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );

    var hintStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
          color: DesignSystem.grey3.withOpacity(0.5),
        );

    return InputDecoration(
      fillColor: DesignSystem.grey1,
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      border: border,
      hintStyle: hintStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLabel(context),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: (value) => onChanged(value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: _inputDecoration(context),
          ),
        ),
      ],
    );
  }
}

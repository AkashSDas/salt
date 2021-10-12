import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/providers/user.dart';
import 'package:salt/services/auth.dart';
import 'package:salt/utils/form/validators.dart';
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
      _invalidSnackBarMsg('Invalid email');
    else if (!checkPassword)
      _invalidSnackBarMsg('Invalid password');
    else {
      final response = await login(_formData);
      if (response[1] != null) {
        _invalidSnackBarMsg('Something went wrong, Please try again');
      } else {
        if (response[0]['error']) {
          _invalidSnackBarMsg(response[0]['message']);
        } else {
          /// Login the user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              response[0]['message'],
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));

          return response[0]['data'];
        }
      }
    }
    return null;
  }

  void _invalidSnackBarMsg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _user = Provider.of<UserProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            FormInputField(
              'email',
              'john@gmail.com',
              'Email',
              _validator.email,
              _formData,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 32),
            FormInputField(
              'password',
              'secure password',
              'Password',
              _validator.password,
              _formData,
              obscureText: true,
            ),
            SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 16),
                    blurRadius: 32,
                    color: Color(0xffFFC21E).withOpacity(0.15),
                  ),
                  BoxShadow(
                    offset: Offset(0, -8),
                    blurRadius: 16,
                    color: Color(0xffFFC21E).withOpacity(0.05),
                  ),
                ],
              ),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor,
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 20, horizontal: 56),
                  ),
                ),
                onPressed: () async {
                  var data = await _submit();
                  if (data != null) {
                    _user.login(data);
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.popAndPushNamed(context, '/home');
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Sofia Pro',
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

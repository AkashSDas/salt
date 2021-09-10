import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:salt/widgets/form/input.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {'email': '', 'username': '', 'password': ''};

  final _usernameValidator = MultiValidator([
    RequiredValidator(errorText: 'Username is required'),
    MinLengthValidator(
      3,
      errorText: 'Username must be at least 3 characters long',
    ),
  ]);

  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(
      6,
      errorText: 'Password should be atleast of 6 characters',
    ),
  ]);

  /// Submit
  void _submit() {
    bool checkUsername = _usernameValidator.isValid(_formData['username']);
    bool checkEmail = _emailValidator.isValid(_formData['email']);
    bool checkPassword = _passwordValidator.isValid(_formData['password']);

    if (!checkUsername)
      _invalidSnackBarMsg('Invalid username');
    else if (!checkEmail)
      _invalidSnackBarMsg('Invalid email');
    else if (!checkPassword) _invalidSnackBarMsg('Invalid password');
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            FormInputField(
              'username',
              'John Smith',
              'Username',
              _usernameValidator,
              _formData,
            ),
            SizedBox(height: 32),
            FormInputField(
              'email',
              'john@gmail.com',
              'Email',
              _emailValidator,
              _formData,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 32),
            FormInputField(
              'password',
              'secure password',
              'Password',
              _passwordValidator,
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
                onPressed: () => _submit(),
                child: Text(
                  'Sign Up',
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

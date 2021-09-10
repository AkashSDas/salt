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
    MinLengthValidator(
      6,
      errorText: 'Password should be atleast of 6 characters',
    ),
  ]);

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
          ],
        ),
      ),
    );
  }
}

import 'package:form_field_validator/form_field_validator.dart';

class SignUpFormValidators {
  final username = MultiValidator([
    RequiredValidator(errorText: 'Username is required'),
    MinLengthValidator(
      3,
      errorText: 'Username must be at least 3 characters long',
    ),
  ]);

  final email = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final password = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(
      6,
      errorText: 'Password should be atleast of 6 characters',
    ),
  ]);

  final dateOfBirth = MultiValidator([
    RequiredValidator(errorText: 'Date of birth is required'),
  ]);
}

class LoginFormValidators {
  final email = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final password = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(
      6,
      errorText: 'Password should be atleast of 6 characters',
    ),
  ]);
}

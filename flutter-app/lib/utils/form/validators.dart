import 'package:form_field_validator/form_field_validator.dart';

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

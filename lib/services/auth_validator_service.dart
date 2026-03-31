class AuthValidatorService {
  final _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final _phoneNumberRegExp = RegExp(r'^\+?[0-9\s\-()\/]{8,20}$');

  bool isEmailValid(String value) =>
      _emailRegExp.hasMatch(value) && !value.contains(' ');

  bool isPasswordValid(String value) => value.length >= 8 && value.length <= 20;

  bool isFullNameValid(String value) =>
      value.length >= 3 && value.length <= 256;

  bool isPhoneNumberValid(String value) => _phoneNumberRegExp.hasMatch(value);
}

part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  const RegisterState({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.status,
    this.errorMessage,
    this.fullNameErrorMessage,
    this.phoneNumberErrorMessage,
    this.emailErrorMessage,
    this.passwordErrorMessage,
    this.registerSuccess,
  });

  RegisterState copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? password,
    RegisterStatus? status,
    String? errorMessage,
    String? fullNameErrorMessage,
    String? phoneNumberErrorMessage,
    String? emailErrorMessage,
    String? passwordErrorMessage,
    AuthSuccess? registerSuccess,
  }) => RegisterState(
    fullName: fullName ?? this.fullName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    password: password ?? this.password,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    fullNameErrorMessage: fullNameErrorMessage,
    phoneNumberErrorMessage: phoneNumberErrorMessage,
    emailErrorMessage: emailErrorMessage,
    passwordErrorMessage: passwordErrorMessage,
    registerSuccess: registerSuccess,
  );

  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  final RegisterStatus status;
  final String? errorMessage;
  final String? fullNameErrorMessage;
  final String? phoneNumberErrorMessage;
  final String? emailErrorMessage;
  final String? passwordErrorMessage;
  final AuthSuccess? registerSuccess;

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    email,
    password,
    status,
    errorMessage,
    fullNameErrorMessage,
    phoneNumberErrorMessage,
    emailErrorMessage,
    passwordErrorMessage,
    registerSuccess,
  ];
}

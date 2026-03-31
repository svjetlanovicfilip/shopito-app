part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    this.errorMessage,
    this.emailErrorMessage,
    this.passwordErrorMessage,
    this.authSuccess,
  });

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? errorMessage,
    String? emailErrorMessage,
    String? passwordErrorMessage,
    AuthSuccess? authSuccess,
  }) => LoginState(
    email: email ?? this.email,
    password: password ?? this.password,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    emailErrorMessage: emailErrorMessage,
    passwordErrorMessage: passwordErrorMessage,
    authSuccess: authSuccess,
  );

  final String email;
  final String password;
  final LoginStatus status;
  final String? errorMessage;
  final String? emailErrorMessage;
  final String? passwordErrorMessage;
  final AuthSuccess? authSuccess;

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    errorMessage,
    emailErrorMessage,
    passwordErrorMessage,
    authSuccess,
  ];
}

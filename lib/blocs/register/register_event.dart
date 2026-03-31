part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterFullNameChanged extends RegisterEvent {
  const RegisterFullNameChanged({required this.fullName});

  final String fullName;

  @override
  List<Object> get props => [fullName];
}

class RegisterPhoneNumberChanged extends RegisterEvent {
  const RegisterPhoneNumberChanged({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {}

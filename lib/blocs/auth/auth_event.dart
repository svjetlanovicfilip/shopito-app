part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked({this.authSuccess});

  final AuthSuccess? authSuccess;

  @override
  List<Object?> get props => [authSuccess];
}

class AuthLogout extends AuthEvent {}

class AuthGetCurrentUser extends AuthEvent {}

class AuthUpdateProfile extends AuthEvent {
  final UserResponse user;

  const AuthUpdateProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final String userRole;

  const AuthAuthenticated({required this.userRole});

  @override
  List<Object> get props => [userRole];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthUserLoggedOutSuccess extends AuthState {}

final class AuthUserLoggedOutFailure extends AuthState {}

class AuthCurrentUser extends AuthState {
  final User user;

  const AuthCurrentUser({required this.user});

  @override
  List<Object> get props => [user];
}

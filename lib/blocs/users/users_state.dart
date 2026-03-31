part of 'users_bloc.dart';

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<User> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

final class UsersError extends UsersState {
  final String message;

  const UsersError({required this.message});

  @override
  List<Object> get props => [message];
}

final class UsersOperationInProgress extends UsersState {}

final class UsersOperationSuccess extends UsersState {
  final String message;

  const UsersOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class UsersOperationFailure extends UsersState {
  final String message;

  const UsersOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

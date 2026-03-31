part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersFetch extends UsersEvent {
  final bool isRefresh;

  const UsersFetch({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class UsersChangeRole extends UsersEvent {
  final String userId;
  final String roleName;

  const UsersChangeRole({required this.userId, required this.roleName});

  @override
  List<Object> get props => [userId, roleName];
}

class UsersDelete extends UsersEvent {
  final String userId;

  const UsersDelete({required this.userId});

  @override
  List<Object> get props => [userId];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/user.dart';
import 'package:shopito_app/data/repository/users_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository usersRepository;

  UsersBloc({required this.usersRepository}) : super(UsersInitial()) {
    on<UsersFetch>(_onUsersFetch);
    on<UsersChangeRole>(_onUsersChangeRole);
    on<UsersDelete>(_onUsersDelete);
  }

  final List<User> _users = [];

  Future<void> _onUsersFetch(UsersFetch event, Emitter<UsersState> emit) async {
    if (!event.isRefresh && _users.isNotEmpty) {
      emit(UsersLoaded(users: List.from(_users)));
      return;
    }

    emit(UsersLoading());

    final result = await usersRepository.getUsers();

    result.fold((failure) => emit(UsersError(message: failure.message)), (
      success,
    ) {
      _users
        ..clear()
        ..addAll(success);
      emit(UsersLoaded(users: List.from(_users)));
    });
  }

  Future<void> _onUsersChangeRole(
    UsersChangeRole event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersOperationInProgress());

    final result = await usersRepository.changeUserRole(
      event.userId,
      event.roleName,
    );

    result.fold(
      (failure) => emit(UsersOperationFailure(message: failure.message)),
      (success) {
        final index = _users.indexWhere((c) => c.id == success.id);
        if (index != -1) {
          _users[index] = success;
        }
        emit(UsersOperationSuccess(message: 'Uloga je ažurirana'));
        emit(UsersLoaded(users: List.from(_users)));
      },
    );
  }

  Future<void> _onUsersDelete(
    UsersDelete event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersOperationInProgress());

    final result = await usersRepository.deleteUser(event.userId);

    result.fold(
      (failure) => emit(UsersOperationFailure(message: failure.message)),
      (success) {
        _users.removeWhere((u) => u.id.toString() == event.userId);
        emit(UsersOperationSuccess(message: 'Korisnik je obrisan'));
        emit(UsersLoaded(users: List.from(_users)));
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/auth_success.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/user.dart';
import 'package:shopito_app/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<AuthLogout>(_onLogout);
    on<AuthGetCurrentUser>(_onGetCurrentUser);
    on<AuthUpdateProfile>(_onUpdateProfile);
  }

  final AuthRepository authRepository;

  User? get currentUser => _user;

  User? _user;

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInitial());

    if (event.authSuccess != null) {
      _user = event.authSuccess?.user;
      return;
    }

    final either = await authRepository.checkAuthStatus();

    either.fold((failure) => emit(AuthUnauthenticated()), (authSuccess) {
      _user = authSuccess.user;
      emit(AuthAuthenticated(userRole: authSuccess.user.role ?? ''));
    });
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final result = await authRepository.logout();
    if (result) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGetCurrentUser(
    AuthGetCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthCurrentUser(user: _user!));
  }

  Future<void> _onUpdateProfile(
    AuthUpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authRepository.updateProfile(event.user);
    result.fold((failure) => null, (user) => emit(AuthCurrentUser(user: user)));
  }
}

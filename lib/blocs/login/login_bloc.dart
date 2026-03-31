import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/auth_success.dart';
import 'package:shopito_app/data/repository/auth_repository.dart';
import 'package:shopito_app/services/auth_validator_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthValidatorService authValidatorService;

  LoginBloc({required this.authRepository, required this.authValidatorService})
    : super(
        const LoginState(email: '', password: '', status: LoginStatus.initial),
      ) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    final email = event.email.trim();
    final isEmailValid = authValidatorService.isEmailValid(email);

    emit(
      state.copyWith(
        email: email,
        emailErrorMessage: isEmailValid ? null : 'Email mora biti validan',
      ),
    );
  }

  Future<void> _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final password = event.password.trim();
    final isPasswordValid = authValidatorService.isPasswordValid(password);

    emit(
      state.copyWith(
        password: password,
        passwordErrorMessage:
            isPasswordValid ? null : 'Lozinka mora biti duža od 8 znakova',
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    String? emailErrorMessage;
    String? passwordErrorMessage;

    if (!authValidatorService.isEmailValid(state.email)) {
      emailErrorMessage = 'Email mora biti validan';
    }

    if (!authValidatorService.isPasswordValid(state.password)) {
      passwordErrorMessage = 'Lozinka mora biti validna';
    }

    if (emailErrorMessage != null || passwordErrorMessage != null) {
      emit(
        state.copyWith(
          emailErrorMessage: emailErrorMessage,
          passwordErrorMessage: passwordErrorMessage,
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    final either = await authRepository.login(state.email, state.password);

    either.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: LoginStatus.success,
            errorMessage: null,
            authSuccess: success,
          ),
        );
      },
    );
  }
}

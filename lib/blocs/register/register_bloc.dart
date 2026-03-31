import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/auth_success.dart';
import 'package:shopito_app/data/models/user.dart';
import 'package:shopito_app/data/repository/auth_repository.dart';
import 'package:shopito_app/services/auth_validator_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  final AuthValidatorService authValidatorService;

  RegisterBloc({
    required this.authRepository,
    required this.authValidatorService,
  }) : super(
         const RegisterState(
           fullName: '',
           phoneNumber: '',
           email: '',
           password: '',
           status: RegisterStatus.initial,
         ),
       ) {
    on<RegisterFullNameChanged>(_onNameChanged);
    on<RegisterPhoneNumberChanged>(_onPhoneNumberChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onNameChanged(
    RegisterFullNameChanged event,
    Emitter<RegisterState> emit,
  ) async {
    final fullName = event.fullName.trim();
    final isFullNameValid = authValidatorService.isFullNameValid(fullName);

    emit(
      state.copyWith(
        fullName: fullName,
        fullNameErrorMessage:
            isFullNameValid
                ? null
                : 'Ime i prezime moraju biti duži od 3 i kraći od 256 znakova',
      ),
    );
  }

  Future<void> _onPhoneNumberChanged(
    RegisterPhoneNumberChanged event,
    Emitter<RegisterState> emit,
  ) async {
    final phoneNumber = event.phoneNumber.trim();
    final isPhoneNumberValid = authValidatorService.isPhoneNumberValid(
      phoneNumber,
    );

    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        phoneNumberErrorMessage:
            isPhoneNumberValid ? null : 'Broj telefona mora biti validan',
      ),
    );
  }

  Future<void> _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
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
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    final password = event.password.trim();
    final isPasswordValid = authValidatorService.isPasswordValid(password);

    emit(
      state.copyWith(
        password: password,
        passwordErrorMessage:
            isPasswordValid ? null : 'Lozinka mora biti validna',
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    String? fullnameErrorMessage;
    String? phoneNumberErrorMessage;
    String? emailErrorMessage;
    String? passwordErrorMessage;

    if (!authValidatorService.isFullNameValid(state.fullName)) {
      fullnameErrorMessage =
          'Ime i prezime moraju biti duži od 3 i kraći od 256 znakova';
    }

    if (!authValidatorService.isPhoneNumberValid(state.phoneNumber)) {
      phoneNumberErrorMessage = 'Broj telefona mora biti validan';
    }

    if (!authValidatorService.isEmailValid(state.email)) {
      emailErrorMessage = 'Email mora biti validan';
    }

    if (!authValidatorService.isPasswordValid(state.password)) {
      passwordErrorMessage = 'Lozinka mora biti validna';
    }

    if (fullnameErrorMessage != null ||
        phoneNumberErrorMessage != null ||
        emailErrorMessage != null ||
        passwordErrorMessage != null) {
      emit(
        state.copyWith(
          fullNameErrorMessage: fullnameErrorMessage,
          phoneNumberErrorMessage: phoneNumberErrorMessage,
          emailErrorMessage: emailErrorMessage,
          passwordErrorMessage: passwordErrorMessage,
        ),
      );
      return;
    }

    if (!isFormValid) {
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    final either = await authRepository.register(
      User(
        fullname: state.fullName,
        phone: state.phoneNumber,
        email: state.email,
        password: state.password,
      ),
    );

    either.fold(
      (failure) {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            errorMessage: null,
            registerSuccess: success,
          ),
        );
      },
    );
  }

  bool get isFormValid =>
      state.fullNameErrorMessage == null &&
      state.phoneNumberErrorMessage == null &&
      state.emailErrorMessage == null &&
      state.passwordErrorMessage == null &&
      authValidatorService.isFullNameValid(state.fullName) &&
      authValidatorService.isPhoneNumberValid(state.phoneNumber) &&
      authValidatorService.isEmailValid(state.email) &&
      authValidatorService.isPasswordValid(state.password);
}

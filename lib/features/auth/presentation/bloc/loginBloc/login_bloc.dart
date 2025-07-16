import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix_app/features/auth/presentation/bloc/loginBloc/login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginFormState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final currentState = state as LoginFormState;
    final isEmailValid = _isValidEmail(event.email);
    final isFormValid = isEmailValid && currentState.isPasswordValid;

    emit(currentState.copyWith(
      email: event.email,
      isEmailValid: isEmailValid,
      isFormValid: isFormValid,
    ));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final currentState = state as LoginFormState;
    final isPasswordValid = _isValidPassword(event.password);
    final isFormValid = currentState.isEmailValid && isPasswordValid;

    emit(currentState.copyWith(
      password: event.password,
      isPasswordValid: isPasswordValid,
      isFormValid: isFormValid,
    ));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Add your authentication logic here
      // For now, we'll simulate success
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  void _onPasswordVisibilityToggled(
      LoginPasswordVisibilityToggled event, Emitter<LoginState> emit) {
    final currentState = state as LoginFormState;
    emit(currentState.copyWith(
      isPasswordVisible: !currentState.isPasswordVisible,
    ));
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}

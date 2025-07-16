import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix_app/features/auth/presentation/bloc/loginBloc/login_event.dart';
import 'package:phoenix_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:phoenix_app/core/utils/secure_storage.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginFormState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    if (state is! LoginFormState) return;
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
    if (state is! LoginFormState) return;
    final currentState = state as LoginFormState;
    final isPasswordValid = _isValidPassword(event.password);
    final isFormValid = currentState.isEmailValid && isPasswordValid;

    emit(currentState.copyWith(
      password: event.password,
      isPasswordValid: isPasswordValid,
      isFormValid: isFormValid,
    ));
  }

  Future<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    final currentState = state as LoginFormState;
    emit(LoginLoading());
    try {
      final authToken = await loginUseCase(
        email: currentState.email,
        password: currentState.password,
      );
      // Print the API response (token)
      print('Login API response token: ${authToken.token}');
      // Store token securely
      await SecureStorage.write('auth_token', authToken.token);
      emit(LoginSuccess());
      // Navigation to dashboard should be handled in the UI after LoginSuccess
    } catch (e) {
      // Print the real error to the console
      print('Login error: \\${e.toString()}');
      String userMessage = 'An unexpected error occurred. Please try again.';
      final errorStr = e.toString();
      if (errorStr.contains('401') || errorStr.contains('Invalid')) {
        userMessage = 'Invalid email or password. Please try again.';
      } else if (errorStr.contains('SocketException')) {
        userMessage = 'No internet connection. Please check your network.';
      } else if (errorStr.contains('timeout')) {
        userMessage = 'Request timed out. Please try again.';
      }
      emit(LoginFailure(userMessage));
      // After a short delay, reset to form state with previous values
      await Future.delayed(const Duration(milliseconds: 300));
      emit(currentState.copyWith());
    }
  }

  void _onPasswordVisibilityToggled(
      LoginPasswordVisibilityToggled event, Emitter<LoginState> emit) {
    if (state is LoginFormState) {
      final currentState = state as LoginFormState;
      emit(currentState.copyWith(
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    } else {
      emit(const LoginFormState(isPasswordVisible: true));
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}

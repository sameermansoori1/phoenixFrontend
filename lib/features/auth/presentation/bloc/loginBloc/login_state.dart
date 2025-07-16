part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LoginFormState extends LoginState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isFormValid = false,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isFormValid,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        isPasswordVisible,
        isEmailValid,
        isPasswordValid,
        isFormValid,
      ];
}

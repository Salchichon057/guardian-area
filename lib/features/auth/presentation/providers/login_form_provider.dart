//! 1.- State del provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:guardian_area/shared/shared.dart';

import 'auth_provider.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return '''
      LoginFormState {
        isPosting: $isPosting,
        isFormPosted: $isFormPosted,
        isValid: $isValid,
        email: $email,
        password: $password,
      }
    ''';
  }
}

//! 2.- Como implementamos un notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() async {
    _touchAllFields();
    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback(state.email.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  _touchAllFields() {
    final email =
        Email.dirty(state.email.value); // Esto es para que se active el error
    final password = Password.dirty(
        state.password.value); // Esto es para que se active el error

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

//! 3.- StateNotifierProvider - Consume Afuerzas el provider

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

// El autoDispose es para que se elimine el provider cuando no se use, en este caso cuando se cierre la pantalla de login y ya haya ingresado a la app, no se necesita el provider, por lo que se elimina
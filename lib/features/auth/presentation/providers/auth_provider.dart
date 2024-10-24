import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/auth/domain/domain.dart';

import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_service_impl.dart';

import '../../infrastructure/infrastructure.dart';


enum AuthStatus { checking, authenticated, unauthenticated }


class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;
  
  AuthState ({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService
  }): super(AuthState()){
    checkAuthStatus();
  }

  Future<void> loginUser (String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);

    } on WrongCredentials {
      logout('Credenciales incorrectas');
    } on ConnectionTimeout{
      logout('Tiempo de conexión agotado');
    } catch (e) {
      logout('Error no encontrado');
    }

    // final user = await authRepository.login(email, password);
    // state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  }

  void registerUser (String email, String password, String fullName) async {

  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if( token == null ) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);

    } catch (e) {
      logout();
    }

  }

  void _setLoggedUser(User user) async {
    // ? Guardando el token físicamente
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout ([String? errorMessage]) async {
    // ? Eliminando el token físicamente
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();

  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService
  );
});
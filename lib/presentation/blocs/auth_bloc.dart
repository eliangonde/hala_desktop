import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hala_desktop/application/services/auth_service.dart';
import 'package:path/path.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    // 🔐 LOGIN
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await _authService.login({
          'email': event.email,
          'password': event.password,
        });

        if (success) {
          final token = await _authService.getAuthToken();
          if (token != null) {
            final user = await _authService.getUser();
            emit(AuthSuccess(token: token, user: user));
          } else {
            emit(AuthFailure('Failed to retrieve user token.'));
          }
        } else {
          emit(AuthFailure('Invalid credentials or login failed.'));
        }
      } catch (e) {
        print('Login Error: ${e.toString()}');
        emit(AuthFailure('Login Error: ${e.toString()}'));
      }
    });

    // 📝 REGISTER
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _authService.register({
          'name': event.name,
          'email': event.email,
          'password': event.password,
        });

        final token = result['token'];
        final user = result['user'];

        if (user != null && token != null) {
          emit(AuthSuccess(token: token, user: user));
        } else {
          emit(AuthFailure('Registration failed. Missing user or token.'));
        }
      } catch (e) {
        emit(AuthFailure('Register Error: ${e.toString()}'));
      }
    });

    // 🟡 APP STARTED
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await _authService.getAuthToken();
        if (token != null) {
          final user = await _authService.getUser();
          emit(AuthSuccess(token: token, user: user));
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthInitial());
      }
    });

    // 🚪 LOGOUT
    on<LogoutRequested>((event, emit) async {
      await _authService.logout();
      emit(AuthInitial());
    });
  }
}

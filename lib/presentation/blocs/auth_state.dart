import 'package:equatable/equatable.dart';
import 'package:hala_desktop/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final User user;

  AuthSuccess({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

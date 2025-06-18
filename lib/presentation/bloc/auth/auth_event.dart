part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final User? user;
  const AuthUserChanged(this.user);
}

class AuthSignOutRequested extends AuthEvent {}

class AuthSignInWithGoogleRequested extends AuthEvent {}
class AuthGuestLoginRequested extends AuthEvent {}
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignUpRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}
part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, guest, unknown, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticated(User user) : this._(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  const AuthState.error(String message) : this._(status: AuthStatus.error, errorMessage: message);
  
  
  const AuthState.guest() : this._(status: AuthStatus.guest);

  @override
  List<Object?> get props => [status, user, errorMessage];
}
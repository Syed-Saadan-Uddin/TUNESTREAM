import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    _userSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user));
    });

    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthGuestLoginRequested>((event, emit) {
      emit(const AuthState.guest());
    });
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(event.user != null
        ? AuthState.authenticated(event.user!)
        : const AuthState.unauthenticated());
  }
  
 
  void _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signUpWithEmailAndPassword(
          email: event.email, password: event.password);
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'An unknown sign-up error occurred.'));
    }
  }

  void _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'An unknown sign-in error occurred.'));
    }
  }

  void _onSignInWithGoogleRequested(
      AuthSignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
       emit(AuthState.error(e.message ?? 'An unknown Google sign-in error occurred.'));
    } catch (e) {
       emit(AuthState.error('An unexpected error occurred during Google Sign-In.'));
    }
  }

  void _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
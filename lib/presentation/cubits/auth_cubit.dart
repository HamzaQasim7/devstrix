import 'package:devstrix/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class EmailUnverified extends AuthState {
  final User user;
  const EmailUnverified(this.user);
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        if (user.emailVerified) {
          emit(Authenticated(user));
        } else {
          emit(EmailUnverified(user));
        }
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _authRepository.signIn(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        if (credential.user!.emailVerified) {
          emit(Authenticated(credential.user!));
        } else {
          emit(EmailUnverified(credential.user!));
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Authentication failed'));
    } catch (e) {
      emit(AuthError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String fullName,
    String gender,
    String dateOfBirth,
    String phone,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        phone: phone,
      );
      await _authRepository.sendEmailVerification();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkEmailVerification() async {
    final verified = await _authRepository.isEmailVerified();
    if (verified) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      }
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _authRepository.sendEmailVerification();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}

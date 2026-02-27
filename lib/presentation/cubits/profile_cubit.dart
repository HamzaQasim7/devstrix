import 'package:devstrix/data/models/user_model.dart';
import 'package:devstrix/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileState {}

// Cubit
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit(this._authRepository) : super(ProfileInitial());

  Future<void> fetchProfile(String uid) async {
    emit(ProfileLoading());
    try {
      final user = await _authRepository.getUserData(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(UserModel user) async {
    emit(ProfileLoading());
    try {
      await _authRepository.updateUserData(user);
      emit(ProfileUpdated());
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

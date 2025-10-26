import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_err.dart';
import '../../../core/utils/helpers/pref_helper.dart';
import '../../Auth/data/model/user_model.dart';
import '../../Auth/data/repo/auth_repo.dart';
import '../data/repo/profile_repo.dart';

part 'profile_state.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepo authRepo;
  final ProfileRepo profileRepo;
  File? profileImage;
  UserModel? user;

  ProfileCubit(this.authRepo, this.profileRepo) : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    try {
      final fetchedUser = await authRepo.getUserProfile();
      if (fetchedUser == null) throw Exception("User data is null");

      await PrefHelper.saveUserData(
        username: fetchedUser.username ?? '',
        email: fetchedUser.email ?? '',
        imageUrl: fetchedUser.image,
        token: fetchedUser.token ?? '',
      );

      user = fetchedUser;
      emit(ProfileLoaded(fetchedUser));
    } catch (e) {
      String msg = e is ApiError ? e.message ?? 'API Error' : e.toString();

      final savedData = await PrefHelper.getUserData();
      if (savedData != null) {
        final cachedUser = UserModel(
          username: savedData['username'] ?? '',
          email: savedData['email'] ?? '',
          image: savedData['image'],
          token: savedData['token'],
        );
        emit(ProfileLoaded(cachedUser));
      } else {
        emit(ProfileError(msg));
      }
    }
  }

  Future<void> uploadProfileImage(File image) async {
    profileImage = image;
    emit(ProfileImagePicked(image));
  }

  Future<void> updateProfile({
    required String username,
    required String email,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    emit(ProfileUpdating());
    try {
      final updatedUser = await profileRepo.updateProfile(
        username: username,
        email: email,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        image: profileImage,
      );
      user = updatedUser;
      emit(ProfileUpdated(updatedUser));
    } catch (e) {
      String msg = e is ApiError ? e.message ?? 'API Error' : e.toString();
      emit(ProfileError(msg));
    }
  }
  Future<void> logout(BuildContext context) async {
    try {
      await authRepo.logout(); // استدعاء الميثود من الريبو
      Navigator.of(context).pushReplacementNamed('/login'); // ارجاع المستخدم لشاشة الدخول
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
}


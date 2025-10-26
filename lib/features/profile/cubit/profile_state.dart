part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}
class ProfileUpdating extends ProfileState {}
class ProfileUpdated extends ProfileState {
  final UserModel user;
  ProfileUpdated(this.user);
}
class ProfileImagePicked extends ProfileState {
  final File image;
  ProfileImagePicked(this.image);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

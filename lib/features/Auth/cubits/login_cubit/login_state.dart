part of 'login_cubit.dart';

@immutable
class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel user;
  LoginSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
  @override
  List<Object?> get props => [error];
}


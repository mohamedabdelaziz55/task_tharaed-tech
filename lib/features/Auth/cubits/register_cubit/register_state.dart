part of 'register_cubit.dart';

@immutable
abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> response;
  RegisterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

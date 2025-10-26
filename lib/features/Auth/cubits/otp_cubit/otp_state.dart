part of 'otp_cubit.dart';

@immutable
abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {}

class OtpTimerTick extends OtpState {
  final int seconds;
  final bool canResend;
  final bool showOtpBanner;
  final String otp;

  const OtpTimerTick(this.seconds, this.canResend, this.showOtpBanner, {this.otp = ''});

  @override
  List<Object?> get props => [seconds, canResend, showOtpBanner, otp];
}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpError extends OtpState {
  final String message;
  const OtpError(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpResent extends OtpState {}
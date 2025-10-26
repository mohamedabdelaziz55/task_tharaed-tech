import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../data/repo/auth_repo.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepo authRepo;
  OtpCubit(this.authRepo) : super(OtpInitial());

  bool showOtpBanner = true;
  int secondsRemaining = 60;
  bool canResend = false;
  Timer? _timer;

  void startTimer() {
    canResend = false;
    secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        emit(OtpTimerTick(secondsRemaining, canResend, showOtpBanner));
      } else {
        canResend = true;
        timer.cancel();
        emit(OtpTimerTick(secondsRemaining, canResend, showOtpBanner));
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      showOtpBanner = false;
      emit(OtpTimerTick(secondsRemaining, canResend, showOtpBanner));
    });
  }

  Future<void> verifyOtp({
    required String email,
    required String enteredOtp,
  }) async {
    emit(OtpLoading());
    try {
      final response = await authRepo.verifyOtp(email: email, otp: enteredOtp);
      if (response['status'] == 'success') {
        emit(OtpSuccess());
      } else {
        emit(OtpError(response['message'] ?? 'OTP verification failed'));
      }
    } catch (e) {
      emit(OtpError('Error verifying OTP: $e'));
    }
  }

  void resendOtp(String newOtp) {
    startTimer();
    showOtpBanner = true;
    emit(OtpTimerTick(secondsRemaining, canResend, showOtpBanner, otp: newOtp));
    Future.delayed(const Duration(seconds: 5), () {
      showOtpBanner = false;
      emit(OtpTimerTick(secondsRemaining, canResend, showOtpBanner, otp: newOtp));
    });
    emit(OtpResent());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

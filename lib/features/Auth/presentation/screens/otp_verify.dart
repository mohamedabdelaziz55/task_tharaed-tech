import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/helper_methods.dart';
import 'package:task_tharad_tech/features/profile/presentation/screens/profile_screen.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/image_assets.dart';
import '../widgets/register_widgets/gradient_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OtpVerificationBody());
  }
}

class OtpVerificationBody extends StatefulWidget {
  const OtpVerificationBody({super.key});

  @override
  State<OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<OtpVerificationBody> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  void _onOtpComplete() {
    final otp = _controllers.map((e) => e.text).join();
    debugPrint("Entered OTP: $otp");
  }

  void _resendCode() {
    debugPrint("Resending code...");
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.08),

              // Logo
              Image.asset(ImageAssets.logo, width: size.width * 0.45),

              SizedBox(height: size.height * 0.06),

              // Title
              Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: size.height * 0.015),

              Text(
                "Please enter the 4-digit code sent to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: size.height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    child: TextField(
                      controller: _controllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.primaryColor),
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(AppColors.primaryColor),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (index == 3 && value.isNotEmpty) {
                          _onOtpComplete();
                        }
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.06),

              // Timer Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Didn’t receive a code? ",
                    style: TextStyle(
                      fontSize: size.width * 0.030,
                      color: Color(AppColors.primaryColor),
                    ),
                  ),
                  _canResend
                      ? GestureDetector(
                          onTap: _resendCode,
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.030,
                            ),
                          ),
                        )
                      : Text(
                          " 00:${_secondsRemaining.toString().padLeft(2, '0')} Sec",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.030,
                            color: Colors.grey,
                          ),
                        ),
                ],
              ),
              // Verify Button
              SizedBox(height: size.height * 0.04),
              GradientButton(
                title: "Verify",
                onPressed: () {
                  navigateTo(ProfileScreen(), canPop: false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/features/profile/presentation/screens/profile_screen.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/image_assets.dart';
import '../widgets/register_widgets/gradient_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String otp; // OTP اللي جاي من API
  final String email; // للإرسال إذا احتجته لاحقًا
  const OtpVerificationScreen({super.key, required this.otp, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpVerificationBody(otp: otp, email: email),
    );
  }
}

class OtpVerificationBody extends StatefulWidget {
  final String otp;
  final String email;
  const OtpVerificationBody({super.key, required this.otp, required this.email});

  @override
  State<OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<OtpVerificationBody> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  bool _showOtpBanner = true; // التحكم في ظهور الرسالة

  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // اخفاء رسالة الـ OTP بعد 5 ثواني
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showOtpBanner = false);
      }
    });
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
    final enteredOtp = _controllers.map((e) => e.text).join();
    debugPrint("Entered OTP: $enteredOtp");

    if (enteredOtp == widget.otp) {
      navigateTo(ProfileScreen(), canPop: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect OTP, please try again."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _resendCode() {
    debugPrint("Resending code...");
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("OTP has been resent."),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08, vertical: size.height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),

              // رسالة OTP واضحة أعلى الشاشة
              if (_showOtpBanner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Your OTP is: ${widget.otp}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(height: size.height * 0.03),

              Image.asset(ImageAssets.logo, width: size.width * 0.45),
              SizedBox(height: size.height * 0.06),
              Text(
                "Verification Code",
                style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.015),
              Text(
                "Please enter the 4-digit code sent to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.04, color: Colors.grey[600]),
              ),
              SizedBox(height: size.height * 0.05),

              // OTP TextFields
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
                          borderSide: BorderSide(color: Color(AppColors.primaryColor), width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) FocusScope.of(context).nextFocus();
                        if (index == 3 && value.isNotEmpty) _onOtpComplete();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.06),

              // Timer & Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Didn’t receive a code? ",
                    style: TextStyle(fontSize: size.width * 0.030, color: Color(AppColors.primaryColor)),
                  ),
                  _canResend
                      ? GestureDetector(
                    onTap: _resendCode,
                    child: Text(
                      "Resend",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: size.width * 0.030),
                    ),
                  )
                      : Text(
                    " 00:${_secondsRemaining.toString().padLeft(2, '0')} Sec",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: size.width * 0.030, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              GradientButton(title: "Verify", onPressed: _onOtpComplete),
            ],
          ),
        ),
      ),
    );
  }
}

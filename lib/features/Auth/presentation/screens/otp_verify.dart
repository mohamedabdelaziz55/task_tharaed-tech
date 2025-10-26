import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_tharad_tech/features/profile/presentation/screens/profile_screen.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../cubits/otp_cubit/otp_cubit.dart';
import '../widgets/register_widgets/gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otp;
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.otp,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(AuthRepo())..startTimer(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            navigateTo(const LoginScreen(), canPop: false);
          } else if (state is OtpError) {
            SnackbarUtils.showSnackBar(
              context,
              state.message,
              isError: true,
              title: "Error",
            );
          } else if (state is OtpResent) {
            SnackbarUtils.showSnackBar(
              context,
              "OTP has been resent.",
              isError: false,
              title: "Success",
            );
          }
        },

        builder: (context, state) {
          final cubit = context.read<OtpCubit>();
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
                    SizedBox(height: size.height * 0.05),

                    if (state is OtpTimerTick && state.showOtpBanner)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Your OTP is: ${state.otp.isNotEmpty ? state.otp : widget.otp}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    SizedBox(height: size.height * 0.03),
                    Image.asset(ImageAssets.logo, width: size.width * 0.45),
                    SizedBox(height: size.height * 0.06),

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
                            controller: controllers[index],
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
                                borderSide:
                                BorderSide(color: Colors.grey.shade400),
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
                                final enteredOtp =
                                controllers.map((e) => e.text).join();
                                cubit.verifyOtp(
                                  email: widget.email,
                                  enteredOtp: enteredOtp,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.06),

                    /// Timer + Resend
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
                        cubit.canResend
                            ? GestureDetector(
                          onTap: () {
                            cubit.resendOtp(widget.otp);
                          },
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
                          " 00:${cubit.secondsRemaining.toString().padLeft(2, '0')} Sec",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.030,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.04),

                    GradientButton(
                      title: state is OtpLoading ? "Verifying..." : "Verify",
                      onPressed: () {
                        final enteredOtp =
                        controllers.map((e) => e.text).join();
                        cubit.verifyOtp(
                          email: widget.email,
                          enteredOtp: enteredOtp,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

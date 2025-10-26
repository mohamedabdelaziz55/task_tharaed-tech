import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/image_assets.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';
import '../../../../core/widgets/snackbar_utils.dart';
import '../../cubits/otp_cubit/otp_cubit.dart';
import '../widgets/register_widgets/gradient_button.dart';
import '../../../../generated/l10n.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otp;
  final String email;
  final void Function(Locale) setLocale;

  const OtpVerificationScreen({
    super.key,
    required this.otp,
    required this.email,
    required this.setLocale,
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
            SnackbarUtils.showSnackBar(
              context,
              S.of(context).otpResent,
              isError: false,
              title: S.of(context).registrationSuccess,
            );
            navigateTo(
              LoginScreen(setLocale: widget.setLocale),
              canPop: false,
            );
          } else if (state is OtpError) {
            SnackbarUtils.showSnackBar(
              context,
              state.message,
              isError: true,
              title: S.of(context).error,
            );
          } else if (state is OtpResent) {
            SnackbarUtils.showSnackBar(
              context,
              S.of(context).otpResent,
              isError: false,
              title: S.of(context).success,
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
                          "${S.of(context).youOtpIs}: ${state.otp.isNotEmpty ? state.otp : widget.otp}",
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
                      S.of(context).verificationCode,
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Text(
                      S.of(context).PleaseEnterOtp,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).didntReceiveACode,
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
                            S.of(context).resend,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.030,
                            ),
                          ),
                        )
                            : Text(
                          "00:${cubit.secondsRemaining.toString().padLeft(2, '0')} ${S.of(context).sec}",
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
                      title: state is OtpLoading
                          ? S.of(context).verify
                          : S.of(context).verify,
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

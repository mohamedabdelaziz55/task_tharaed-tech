// lib/features/Auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/core/utils/snackbar_utils.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import 'package:task_tharad_tech/features/profile/presentation/screens/profile_screen.dart';

import '../../../../generated/l10n.dart';
import '../../cubits/login_cubit/login_cubit.dart';
import '../widgets/login_widgets/login_body.dart';

class LoginScreen extends StatelessWidget {
  final void Function(Locale) setLocale; // ✅ أضف هذا

  const LoginScreen({super.key, required this.setLocale}); // ✅ عدّل الكونستركتور

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(AuthRepo()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.popUntil(context, (route) => route.isFirst);
          }

          if (state is LoginSuccess) {
            SnackbarUtils.showSnackBar(context, S.of(context).loginSuccessful);
            navigateTo(
              ProfileScreen(setLocale: setLocale),
              canPop: false,
            );
          } else if (state is LoginFailure) {
            SnackbarUtils.showSnackBar(
              context,
              state.error,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          return  Scaffold(body: LoginBody(setLocale: setLocale,));
        },
      ),
    );
  }
}

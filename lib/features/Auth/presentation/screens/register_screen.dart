import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import 'package:task_tharad_tech/features/Auth/presentation/widgets/register_widgets/register_body.dart';

import '../../cubits/register_cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(AuthRepo()),
      child: const Scaffold(
        body: RegisterBody(),
      ),
    );
  }
}

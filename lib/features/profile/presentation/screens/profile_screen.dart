import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';
import 'package:task_tharad_tech/features/profile/data/repo/profile_repo.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import '../../cubit/profile_cubit.dart';
import '../widgets/profile_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(AuthRepo(), ProfileRepo())..loadUserProfile(),
      child: Scaffold(
        body: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(AppColors.gradientColor1),
                Color(AppColors.gradientColor2),
              ],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
          child: SafeArea(child: ProfileBody()),
        ),
      ),
    );
  }
}

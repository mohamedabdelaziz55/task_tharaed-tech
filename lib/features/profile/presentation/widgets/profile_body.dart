import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import '../../../Auth/presentation/widgets/register_widgets/gradient_button.dart';
import '../../../Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import '../../cubit/profile_cubit.dart';
import 'custom_app_bar.dart';
import '../../../../generated/l10n.dart';

class ProfileBody extends StatelessWidget {
  final void Function(Locale) setLocale; // ✅ أضف هذا

  ProfileBody({super.key, required this.setLocale}); // ✅ عدّل الكونستركتور

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          SnackbarUtils.showSnackBar(
            context,
            '${S.of(context).error}: ${state.message}',
            isError: true,
            title: S.of(context).error,
          );
        }
        if (state is ProfileUpdated) {
          SnackbarUtils.showSnackBar(
            context,
            S.of(context).profileUpdatedSuccessfully,
            isError: false,
            title: S.of(context).success,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoaded || state is ProfileUpdated) {
          final user = cubit.user ?? (state is ProfileLoaded ? state.user : null);
          if (user != null) {
            _usernameController.text = user.username ?? '';
            _emailController.text = user.email ?? '';
          }
        }

        final imagePath = cubit.profileImage?.path ?? cubit.user?.image;

        return Column(
          children: [
             CustomAppBar(setLocale:setLocale,),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileImageUploader(
                        initialImageUrl: imagePath,
                        onImagePicked: (file) => cubit.uploadProfileImage(file),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        title: S.of(context).userName,
                        controller: _usernameController,
                      ),
                      CustomTextField(
                        title: S.of(context).email,
                        controller: _emailController,
                      ),
                      CustomTextField(
                        title: S.of(context).oldPassword,
                        controller: _oldPasswordController,
                        isPasswordField: true,
                      ),
                      CustomTextField(
                        title: S.of(context).newPassword,
                        controller: _newPasswordController,
                        isPasswordField: true,
                      ),
                      CustomTextField(
                        title: S.of(context).confirmNewPassword,
                        controller: _confirmPasswordController,
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        title: state is ProfileUpdating
                            ? S.of(context).updating
                            : S.of(context).updateProfile,
                        onPressed: state is ProfileUpdating
                            ? null
                            : () => cubit.updateProfile(
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          oldPassword: _oldPasswordController.text.trim().isEmpty
                              ? null
                              : _oldPasswordController.text.trim(),
                          newPassword: _newPasswordController.text.trim().isEmpty
                              ? null
                              : _newPasswordController.text.trim(),
                          confirmPassword: _confirmPasswordController.text.trim().isEmpty
                              ? null
                              : _confirmPasswordController.text.trim(),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await cubit.logout(context, setLocale); // ✅ تمرير setLocale
                        },
                        child: Text(
                          S.of(context).logout,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

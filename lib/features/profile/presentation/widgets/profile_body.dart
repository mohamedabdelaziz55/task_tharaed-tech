import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import '../../../Auth/presentation/widgets/register_widgets/gradient_button.dart';
import '../../../Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import '../../cubit/profile_cubit.dart';
import 'custom_app_bar.dart';
import '../../../../core/utils/helpers/pref_helper.dart';

class ProfileBody extends StatelessWidget {
  ProfileBody({super.key});

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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')));
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: 20),
              ProfileImageUploader(
                initialImageUrl: imagePath,
                onImagePicked: (file) => cubit.uploadProfileImage(file),
              ),
              const SizedBox(height: 20),
              CustomTextField(title: "User Name", controller: _usernameController),
              CustomTextField(title: "Email", controller: _emailController),
              CustomTextField(title: "Old Password", controller: _oldPasswordController, isPasswordField: true),
              CustomTextField(title: "New Password", controller: _newPasswordController, isPasswordField: true),
              CustomTextField(title: "Confirm New Password", controller: _confirmPasswordController, isPasswordField: true),
              const SizedBox(height: 20),
              GradientButton(
                title: state is ProfileUpdating ? 'Updating...' : 'Update Profile',
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
                onPressed: () async => await PrefHelper.clearUserData(),
                child: const Text("Logout", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}

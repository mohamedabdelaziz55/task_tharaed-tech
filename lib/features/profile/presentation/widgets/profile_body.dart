import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/features/Auth/data/model/user_model.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import '../../../../core/network/api_err.dart';
import '../../../../core/utils/helpers/pref_helper.dart';
import '../../../Auth/presentation/widgets/register_widgets/custom_text_field.dart';
import '../../../Auth/presentation/widgets/register_widgets/gradient_button.dart';
import '../../../Auth/presentation/widgets/register_widgets/profile_image_uploader.dart';
import 'custom_app_bar.dart';


class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> with TickerProviderStateMixin {
  File? profileImage;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  UserModel? user;
  bool isLoading = true;
  bool isUpdating = false;

  final AuthRepo authRepo = AuthRepo();
  final ProfileRepo profileRepo = ProfileRepo();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _loadUserProfile() async {
    try {
      final fetchedUser = await authRepo.getUserProfile();

      if (fetchedUser == null) {
        throw Exception("User data is null");
      }

      setState(() {
        user = fetchedUser;
        _usernameController.text = fetchedUser.username ?? '';
        _emailController.text = fetchedUser.email ?? '';
        isLoading = false;
      });

      await PrefHelper.saveUserData(
        username: fetchedUser.username ?? '',
        email: fetchedUser.email ?? '',
        imageUrl: fetchedUser.image,
        token: fetchedUser.token ?? '',
      );
    } catch (e) {
      String errorMessage = e.toString();
      if (e is ApiError) errorMessage = e.message ?? 'API Error';
      print("Failed to load user: $errorMessage");

      final savedData = await PrefHelper.getUserData();
      if (savedData != null) {
        print("Loaded user data from local storage");
        setState(() {
          _usernameController.text = savedData['username'] ?? '';
          _emailController.text = savedData['email'] ?? '';
          user = UserModel(
            username: savedData['username'] ?? '',
            email: savedData['email'] ?? '',
            image: savedData['image'],
            token: savedData['token'],
          );
          isLoading = false;
        });
      } else {
        print("No saved user data found");
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      print("Uploading image: ${image.path}");
      setState(() {
        profileImage = image;
      });
    } catch (e) {
      print("Upload failed: $e");
    }
  }

  Future<void> _updateProfile() async {
    if (isUpdating) return;

    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    // ✅ تحقق محلي من حقول الباسورد
    final bool passwordFieldsFilled =
        oldPass.isNotEmpty || newPass.isNotEmpty || confirmPass.isNotEmpty;

    if (passwordFieldsFilled) {
      // لو دخل واحدة بس من الثلاثة
      if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ من فضلك أدخل جميع حقول كلمة المرور لتغييرها.'),
          ),
        );
        return;
      }

      // لو الجديد لا يساوي التأكيد
      if (newPass != confirmPass) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ كلمة المرور الجديدة غير متطابقة.'),
          ),
        );
        return;
      }

      // لو الجديد نفس القديم (مش منطقي)
      if (newPass == oldPass) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ كلمة المرور الجديدة يجب أن تختلف عن القديمة.'),
          ),
        );
        return;
      }
    }

    setState(() => isUpdating = true);

    try {
      final updatedUser = await profileRepo.updateProfile(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        oldPassword: passwordFieldsFilled ? oldPass : null,
        newPassword: passwordFieldsFilled ? newPass : null,
        confirmPassword: passwordFieldsFilled ? confirmPass : null,
        image: profileImage,
      );

      setState(() {
        user = updatedUser;
        isUpdating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم تحديث الملف الشخصي بنجاح')),
      );
    } catch (e) {
      setState(() => isUpdating = false);
      String errorMsg = e.toString();
      if (e is ApiError) errorMsg = e.message ?? 'API Error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ فشل التحديث: $errorMsg')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final imageUrl = profileImage?.path ?? user?.image;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(w * 0.04), child: const CustomAppBar()),
        SizedBox(height: h * 0.015),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w * 0.04),
                topRight: Radius.circular(w * 0.04),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.025,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileImageUploader(
                        initialImageUrl: imageUrl,
                        onImagePicked: (file) async {
                          await _uploadProfileImage(file);
                        },
                      ),
                      SizedBox(height: h * 0.03),

                      CustomTextField(
                        title: "User Name",
                        controller: _usernameController,
                      ),
                      SizedBox(height: h * 0.015),

                      CustomTextField(
                        title: "Email",
                        controller: _emailController,
                      ),
                      SizedBox(height: h * 0.015),

                      CustomTextField(
                        title: "Old Password",
                        controller: _oldPasswordController,
                        isPasswordField: true,
                      ),
                      SizedBox(height: h * 0.015),

                      CustomTextField(
                        title: "New Password",
                        controller: _newPasswordController,
                        isPasswordField: true,
                      ),
                      SizedBox(height: h * 0.015),

                      CustomTextField(
                        title: "Confirm New Password",
                        controller: _confirmPasswordController,
                        isPasswordField: true,
                      ),
                      SizedBox(height: h * 0.03),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                        child: GradientButton(
                          title: isUpdating ? 'Updating...' : 'Update Profile',
                          onPressed: isUpdating ? null : _updateProfile,
                        ),
                      ),
                      SizedBox(height: h * 0.015),

                      TextButton(
                        onPressed: () async {
                          await PrefHelper.clearUserData();
                          print("Logout pressed");
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/features/Auth/data/model/user_model.dart';
import 'package:task_tharad_tech/features/Auth/data/repo/auth_repo.dart';
import '../../../../core/network/api_err.dart';
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

  final AuthRepo authRepo = AuthRepo();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // تحميل بيانات المستخدم
  Future<void> _loadUserProfile() async {
    try {
      final fetchedUser = await authRepo.getUserProfile();
      setState(() {
        user = fetchedUser;
        _usernameController.text = fetchedUser!.username;
        _emailController.text = fetchedUser.email;
      });
    } catch (e) {
      String errorMessage = e.toString();
      if (e is ApiError) errorMessage = e.message!;
      print("Failed to load user: $errorMessage");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    // ✅ أولاً نحمل المستخدم المحلي مباشرة (يظهر فورًا)
    final localUser = authRepo.currentUser; // استخدم ما عندك من كاش أو حالة حالية
    if (localUser != null) {
      user = localUser;
      _usernameController.text = localUser.username;
      _emailController.text = localUser.email;
      if (localUser.image != null && localUser.image!.isNotEmpty) {
        profileImage = File(localUser.image!);
      }
      isLoading = false;
    }

    // ✅ ثم نحمل من السيرفر لتحديث البيانات بعد الظهور
    _loadUserProfile();

    // إعداد الأنيميشن
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    // لو مفيش بيانات حتى محليًا، اعرض تحميل بسيط
    if (isLoading && user == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
                        onImagePicked: (file) {
                          setState(() {
                            profileImage = file;
                          });
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
                      const CustomTextField(
                        title: "Old Password",
                        isPasswordField: true,
                      ),
                      SizedBox(height: h * 0.015),
                      const CustomTextField(
                        title: "New Password",
                        isPasswordField: true,
                      ),
                      SizedBox(height: h * 0.015),
                      const CustomTextField(
                        title: "Confirm New Password",
                        isPasswordField: true,
                      ),
                      SizedBox(height: h * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.15),
                        child: GradientButton(
                          title: 'Update Profile',
                          onPressed: () {
                            print("Updated username: ${_usernameController.text}");
                            print("Updated email: ${_emailController.text}");
                            if (profileImage != null) {
                              print("New image path: ${profileImage!.path}");
                            }
                          },
                        ),
                      ),
                      SizedBox(height: h * 0.015),
                      TextButton(
                        onPressed: () {
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

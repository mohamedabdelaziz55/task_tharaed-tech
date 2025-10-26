import 'package:flutter/material.dart';
import 'package:task_tharad_tech/features/profile/presentation/screens/profile_screen.dart';

import 'core/utils/helpers/helper_methods.dart';
import 'features/Auth/cubits/login_cubit/login_cubit.dart';
import 'features/Auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await LoginCubit.checkLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "PlayfairDisplay",
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? const ProfileScreen() : const LoginScreen(),
    );
  }
}

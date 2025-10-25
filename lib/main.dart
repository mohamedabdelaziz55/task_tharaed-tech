import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/helpers/helper_methods.dart';
import 'package:task_tharad_tech/features/Auth/presentation/screens/login_screen.dart';


void main()async {
  final dio = Dio();
  try {
    final response = await dio.post(
      'https://flutter.tharadtech.com/api/auth/login',
      data: {'email': 'test@mail.com', 'password': '123456'},
    );
    print(response.data);
  } catch (e) {
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "PlayfairDisplay",
        scaffoldBackgroundColor: Colors.white
      ),
      home: const LoginScreen(),
    );
  }
}


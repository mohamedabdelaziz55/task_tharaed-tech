import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/helpers/helper_methods.dart';
import 'features/Auth/cubits/login_cubit/login_cubit.dart';
import 'features/Auth/presentation/screens/login_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'generated/l10n.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await LoginCubit.checkLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // الوضع الافتراضي انجليزي

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // اختيار الخط حسب اللغة
    final String fontFamily = _locale.languageCode == 'ar' ? 'Almarai' : 'PlayfairDisplay';

    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: fontFamily,
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: widget.isLoggedIn
          ? ProfileScreen(setLocale: setLocale)
          : LoginScreen(setLocale: setLocale),
    );
  }
}

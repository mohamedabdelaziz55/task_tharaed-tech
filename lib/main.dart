import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/helpers/helper_methods.dart';
import 'features/Auth/cubits/login_cubit/login_cubit.dart';
import 'features/Auth/presentation/screens/login_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'generated/l10n.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await LoginCubit.checkLoggedIn();

  final prefs = await SharedPreferences.getInstance();
  final savedLangCode = prefs.getString('locale') ?? 'en';

  runApp(MyApp(isLoggedIn: isLoggedIn, initialLocale: Locale(savedLangCode)));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final Locale initialLocale;
  const MyApp({super.key, required this.isLoggedIn, required this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
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

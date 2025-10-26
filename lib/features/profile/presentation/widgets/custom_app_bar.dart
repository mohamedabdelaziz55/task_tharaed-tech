import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class CustomAppBar extends StatefulWidget {
  final Function(Locale) setLocale;

  const CustomAppBar({super.key, required this.setLocale});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isArabic = true;

  void _toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
    widget.setLocale(isArabic ? const Locale('ar') : const Locale('en'));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          ElevatedButton(
            onPressed: _toggleLanguage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
            ),
            child: Text(
              isArabic ? "AR" : "EN",
              style: const TextStyle(color: Colors.white),
            ),
          ),

          Text(
            S.of(context).profile,
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.055,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: w * 0.06,
            child: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: w * 0.055,
            ),
          ),
        ],
      ),
    );
  }
}

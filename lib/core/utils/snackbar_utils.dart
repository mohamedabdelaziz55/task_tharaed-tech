
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SnackbarUtils {
  static void showSnackBar(
      BuildContext context,
      String message, {
        bool isError = false,
        String? title,
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final backgroundColor = isError ? Colors.redAccent.shade200 : Colors.green.shade400;
    final icon = isError ? LucideIcons.alertCircle : LucideIcons.checkCircle2;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

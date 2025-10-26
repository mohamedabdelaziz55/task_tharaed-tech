import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../generated/l10n.dart';

class LoginOptionsRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onChanged;

  const LoginOptionsRow({
    super.key,
    required this.rememberMe,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: .8,
              child: Checkbox(
                value: rememberMe,
                onChanged: onChanged,
                activeColor: Color(AppColors.primaryColor),
              ),
            ),
            Text(
              S.of(context).rememberMe,
              style: TextStyle(fontSize: size.width * 0.032),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            S.of(context).forgotPassword,
            style: TextStyle(
              fontSize: size.width * 0.032,
              color: Color(AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

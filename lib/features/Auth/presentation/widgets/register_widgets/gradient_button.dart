import 'package:flutter/material.dart';
import 'package:task_tharad_tech/core/utils/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool canTap = !isDisabled && !isLoading;

    return GestureDetector(
      onTap: canTap ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: canTap ? 1 : 0.6,
        child: Container(
          width: double.infinity,
          height: size.height * 0.065,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                Color(AppColors.gradientColor1),
                Color(AppColors.gradientColor2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.2,
            ),
          )
              : Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}

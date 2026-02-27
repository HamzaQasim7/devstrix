import 'package:devstrix/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthFooter extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooter({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText, style: GoogleFonts.inter(color: AppColors.textGrey)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: GoogleFonts.inter(
              color: AppColors.primaryPink,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryPink,
              decorationThickness: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

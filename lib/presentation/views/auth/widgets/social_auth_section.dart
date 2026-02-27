import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/shared/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialAuthSection extends StatelessWidget {
  final VoidCallback onFacebookPressed;
  final VoidCallback onGooglePressed;

  const SocialAuthSection({
    super.key,
    required this.onFacebookPressed,
    required this.onGooglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Or Continue With',
            style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            SocialLoginButton(
              backgroundColor: AppColors.facebookBlue,
              icon: const Icon(
                Icons.facebook,
                color: AppColors.white,
                size: 30,
              ),
              onPressed: onFacebookPressed,
            ),
            const SizedBox(width: 16),
            SocialLoginButton(
              backgroundColor: AppColors.googleRed,
              icon: Text(
                'G',
                style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: onGooglePressed,
            ),
          ],
        ),
      ],
    );
  }
}

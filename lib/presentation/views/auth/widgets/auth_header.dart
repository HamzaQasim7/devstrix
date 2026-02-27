import 'package:devstrix/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showLogo;

  const AuthHeader({
    super.key,
    this.title,
    this.subtitle,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: title != null
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (showLogo)
          Center(
            child: Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYyNrIYqLb0OCXQn5zJzwYsr6IuFTqzWKZBDzvctBlNQ&s',
                  ),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        if (showLogo && title != null) const SizedBox(height: 32),
        if (title != null)
          Text(
            title!,
            style: GoogleFonts.inter(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: GoogleFonts.inter(color: AppColors.textGrey, fontSize: 10),
          ),
        ],
      ],
    );
  }
}

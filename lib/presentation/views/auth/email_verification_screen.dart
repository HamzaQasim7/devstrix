import 'dart:async';
import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/presentation/cubits/auth_cubit.dart';
import 'package:devstrix/presentation/views/auth/widgets/auth_header.dart';
import 'package:devstrix/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool canResendEmail = false;
  Timer? verificationTimer;
  Timer? resendTimer;
  int resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    verificationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      context.read<AuthCubit>().checkEmailVerification();
    });
    _startResendCountdown();
  }

  void _startResendCountdown() {
    if (!mounted) return;
    setState(() {
      canResendEmail = false;
      resendCountdown = 60;
    });
    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (resendCountdown == 0) {
        setState(() {
          canResendEmail = true;
        });
        timer.cancel();
      } else {
        setState(() {
          resendCountdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    verificationTimer?.cancel();
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryPink),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.email_outlined,
                color: AppColors.primaryPink,
                size: 80,
              ),
            ),
            const SizedBox(height: 32),
            const AuthHeader(
              title: 'Verify Your Email',
              subtitle:
                  'We have sent a verification link to your email address. Please click the link to activate your account.',
              showLogo: false,
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'Check Verification Status',
              onPressed: () =>
                  context.read<AuthCubit>().checkEmailVerification(),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: canResendEmail
                  ? () {
                      context.read<AuthCubit>().resendVerificationEmail();
                      _startResendCountdown();
                    }
                  : null,
              child: Text(
                canResendEmail
                    ? 'Resend Verification Email'
                    : 'Resend in ${resendCountdown}s',
                style: GoogleFonts.inter(
                  color: canResendEmail
                      ? AppColors.primaryPink
                      : AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildWaitingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingIndicator() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryPink,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Waiting for verification...',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textGrey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

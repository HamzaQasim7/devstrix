import 'package:devstrix/core/theme/app_theme.dart';
import 'package:devstrix/core/utils/injection_container.dart' as di;
import 'package:devstrix/presentation/cubits/auth_cubit.dart';
import 'package:devstrix/presentation/cubits/profile_cubit.dart';
import 'package:devstrix/presentation/views/auth/sign_in_screen.dart';
import 'package:devstrix/presentation/views/auth/email_verification_screen.dart';
import 'package:devstrix/presentation/views/main_wrapper.dart';
import 'package:devstrix/data/repositories/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Requires google-services.json / GoogleService-Info.plist)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Dependency Injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(di.sl<AuthRepository>()),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(di.sl<AuthRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'DevStrix Task',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) {
        // Only rebuild if the core authentication status changes
        if (previous is Authenticated && current is Authenticated) return false;
        if (previous is Unauthenticated && current is Unauthenticated)
          return false;
        if (previous is EmailUnverified && current is EmailUnverified)
          return false;
        return true;
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return const MainWrapper();
        } else if (state is EmailUnverified) {
          return const EmailVerificationScreen();
        } else {
          // For Unauthenticated, AuthInitial, AuthLoading, or AuthError
          // we stay on the SignInScreen and let it handle local states.
          return const SignInScreen();
        }
      },
    );
  }
}

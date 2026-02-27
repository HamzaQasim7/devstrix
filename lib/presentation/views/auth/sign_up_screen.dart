import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/presentation/cubits/auth_cubit.dart';
import 'package:devstrix/presentation/views/auth/widgets/auth_footer.dart';
import 'package:devstrix/presentation/views/auth/widgets/auth_header.dart';
import 'package:devstrix/shared/widgets/custom_button.dart';
import 'package:devstrix/shared/widgets/custom_dropdown_field.dart';
import 'package:devstrix/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedGender;
  final _dobController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryPink,
              onPrimary: AppColors.white,
              surface: AppColors.darkBg,
              onSurface: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryPink,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day} / ${picked.month} / ${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AuthHeader(title: 'Create Account', showLogo: false),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated || state is EmailUnverified) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: "Let's get you set up",
                  subtitle:
                      "Create your account to start your training journey.",
                  showLogo: false,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Full Name',
                  icon: Icons.person_outline,
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Email Address',
                  hint: 'You@example.com',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomDropdownField(
                  label: 'Gender',
                  hint: 'Select Gender',
                  icon: Icons.person_outline,
                  value: _selectedGender,
                  items: const ['Male', 'Female', 'Other'],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Date Of Birth',
                  hint: 'DD / MM / YYYY',
                  icon: Icons.calendar_today_outlined,
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Password',
                  hint: '••••••••••••',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                BlocBuilder<AuthCubit, AuthState>(
                  buildWhen: (previous, current) =>
                      previous is AuthLoading || current is AuthLoading,
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Create Account',
                      isLoading: state is AuthLoading,
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _fullNameController.text.trim(),
                            _selectedGender ?? '',
                            _dobController.text.trim(),
                            '', // phone placeholder
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                AuthFooter(
                  leadingText: "Already Have An Account? ",
                  actionText: "Sign In",
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

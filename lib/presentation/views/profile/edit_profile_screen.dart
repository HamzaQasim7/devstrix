import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/presentation/cubits/profile_cubit.dart';
import 'package:devstrix/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      _fullNameController.text = state.user.fullName;
      _emailController.text = state.user.email;
      _genderController.text = state.user.gender;
      _dobController.text = state.user.dateOfBirth;
      _phoneController.text = state.user.phone;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Account Settings',
          style: GoogleFonts.inter(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 54,
                    backgroundColor: AppColors.darkBg,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Change Photo',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryPink,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Personal Information',
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsField(
              label: 'Full Name',
              controller: _fullNameController,
              hint: 'Alex Johnson',
            ),
            _buildSettingsField(
              label: 'Email Address',
              controller: _emailController,
              hint: 'alex.johnson@example.com',
            ),
            _buildSettingsField(
              label: 'Gender',
              controller: _genderController,
              hint: 'Male',
            ),
            _buildSettingsField(
              label: 'Date Of Birth',
              controller: _dobController,
              hint: '14 April, 1995',
              readOnly: true,
              onTap: _selectDate,
            ),
            const SizedBox(height: 32),
            Text(
              'Change Password',
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsField(
              label: 'Current Password',
              controller: _currentPasswordController,
              hint: '••••••••',
              obscure: true,
            ),
            _buildSettingsField(
              label: 'New Password',
              controller: _newPasswordController,
              hint: 'Enter new Password',
              obscure: true,
            ),
            _buildSettingsField(
              label: 'Phone Number',
              controller: _phoneController,
              hint: '+123 456 789',
            ),
            const SizedBox(height: 40),
            BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes saved successfully!'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: 'Save Changes',
                  isLoading: state is ProfileLoading,
                  onPressed: () {
                    final currentState = context.read<ProfileCubit>().state;
                    if (currentState is ProfileLoaded) {
                      final updatedUser = currentState.user.copyWith(
                        fullName: _fullNameController.text.trim(),
                        email: _emailController.text.trim(),
                        gender: _genderController.text.trim(),
                        dateOfBirth: _dobController.text.trim(),
                        phone: _phoneController.text.trim(),
                      );
                      context.read<ProfileCubit>().updateProfile(updatedUser);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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

  Widget _buildSettingsField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onTap: onTap,
          readOnly: readOnly,
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.darkBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/presentation/cubits/auth_cubit.dart';
import 'package:devstrix/presentation/cubits/profile_cubit.dart';
import 'package:devstrix/presentation/views/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) {
          if (previous is ProfileLoaded && current is ProfileLoaded) {
            return previous.user != current.user;
          }
          return true;
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.darkBg,
                          backgroundImage: NetworkImage(
                            'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Training with PR Since 2023',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Annual Subscription Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.workspace_premium,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Annual Subscription',
                                  style: GoogleFonts.inter(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cancel anytime • No commitment',
                                  style: GoogleFonts.inter(
                                    color: AppColors.white.withOpacity(0.8),
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildProfileOption(
                      icon: Icons.settings_outlined,
                      title: 'Account Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.credit_card_outlined,
                      title: 'Subscription Management',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.sync_problem_outlined,
                      title: 'Cycle Awareness',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.favorite_border_outlined,
                      title: 'Mindset',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        context.read<AuthCubit>().signOut();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.darkBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, color: AppColors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Log Out',
                              style: GoogleFonts.inter(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.white),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColors.white,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.white,
        ),
      ),
    );
  }
}

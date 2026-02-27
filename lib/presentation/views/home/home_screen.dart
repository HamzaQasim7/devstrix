import 'package:devstrix/core/constants/app_constants.dart';
import 'package:devstrix/presentation/cubits/auth_cubit.dart';
import 'package:devstrix/presentation/cubits/profile_cubit.dart';
import 'package:devstrix/data/models/training_model.dart';
import 'package:devstrix/presentation/views/home/widgets/featured_workout_card.dart';
import 'package:devstrix/presentation/views/home/widgets/home_greeting.dart';
import 'package:devstrix/presentation/views/home/widgets/recommended_workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final user = (context.read<AuthCubit>().state as Authenticated).user;
    context.read<ProfileCubit>().fetchProfile(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Home',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryPink),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) {
          if (previous is ProfileLoaded && current is ProfileLoaded) {
            return previous.user != current.user;
          }
          return true;
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final workouts = TrainingModel.generateDummyData();
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreeting(userName: state.user.fullName),
                  const SizedBox(height: 24),

                  // Featured Plan
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Featured Workouts',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return FeaturedWorkoutCard(workout: workouts[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Recomended Sessions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended For You',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.primaryPink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: workouts.length - 3,
                    itemBuilder: (context, index) {
                      return RecommendedWorkoutCard(
                        workout: workouts[index + 3],
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

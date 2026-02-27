import 'package:faker/faker.dart';

class TrainingModel {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String intensity;
  final String imageUrl;
  final String description;
  final double rating;

  TrainingModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.intensity,
    required this.imageUrl,
    required this.description,
    required this.rating,
  });

  static List<TrainingModel> generateDummyData() {
    final faker = Faker();
    final categories = ['Strength', 'Hiit', 'Yoga', 'Cardio', 'Mobility'];
    final intensities = ['Beginner', 'Intermediate', 'Advanced'];
    final trainingImages = [
      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1470&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=1470&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1594381898411-846e7d193883?q=80&w=1374&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1434682881908-b43d0467b798?q=80&w=1474&auto=format&fit=crop',
    ];

    return List.generate(10, (index) {
      return TrainingModel(
        id: faker.guid.guid(),
        title: '${faker.sport.name()} Training',
        category: categories[faker.randomGenerator.integer(categories.length)],
        duration: '${faker.randomGenerator.integer(60, min: 15)} min',
        intensity:
            intensities[faker.randomGenerator.integer(intensities.length)],
        imageUrl: trainingImages[index % trainingImages.length],
        description: faker.lorem.sentences(2).join(' '),
        rating: faker.randomGenerator.decimal(min: 4.0),
      );
    });
  }
}

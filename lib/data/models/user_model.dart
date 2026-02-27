import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final String dateOfBirth;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? gender,
    String? dateOfBirth,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  List<Object?> get props => [uid, fullName, email, phone, gender, dateOfBirth];
}

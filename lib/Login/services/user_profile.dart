import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String fullName;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phone;
  final String? address;
  final String? gender;
  final String? profilePicture;

  UserProfile({
    required this.uid,
    required this.email,
    required this.fullName,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.address,
    this.gender,
    this.profilePicture,
  });

  // Convert UserProfile to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'phone': phone,
      'address': address,
      'gender': gender,
      'profilePicture': profilePicture,
    };
  }

  // Create UserProfile from Firestore document
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    // The backend writes snake_case keys (created_at) and may omit the
    // camelCase ones, so accept both and fall back to now instead of crashing.
    final now = DateTime.now();
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      dateOfBirth: _toDate(map['dateOfBirth']),
      createdAt: _toDate(map['createdAt'] ?? map['created_at']) ?? now,
      updatedAt: _toDate(map['updatedAt'] ?? map['updated_at']) ?? now,
      phone: map['phone'],
      address: map['address'],
      gender: map['gender'],
      profilePicture: map['profilePicture'],
    );
  }

  // Create UserProfile from Firestore DocumentSnapshot
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile.fromMap(data);
  }

  // Firestore gives a Timestamp; the backend JSON gives ISO strings
  static DateTime? _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  // Create a copy with updated values
  UserProfile copyWith({
    String? uid,
    String? email,
    String? fullName,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? phone,
    String? address,
    String? gender,
    String? profilePicture,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}

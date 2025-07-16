import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

enum Gender {
  male,
  female,
  @JsonValue('')
  unknown,
  other,
}

extension GenderExtension on Gender {
  Icon get icon {
    switch (this) {
      case Gender.male:
        return Icon(Icons.male_outlined, color: Colors.blue);
      case Gender.female:
        return Icon(Icons.female_outlined, color: Colors.pinkAccent);
      case Gender.unknown:
        return Icon(Icons.question_mark_outlined, color: Colors.grey);
      case Gender.other:
        return Icon(Icons.transgender_outlined, color: Colors.brown);
    }
  }

  String get description {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.unknown:
        return 'Unknown';
      case Gender.other:
        return 'Other';
    }
  }
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class Profile {
  @JsonKey(name: 'documentID')
  final String id;

  final String name;
  final String email;
  final String phone;
  final Gender gender;

  @TimestampConverter()
  final DateTime dateOfBirth;
  @JsonKey(name: 'avatar')
  final String avatarUrl;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    Gender? gender,
    DateTime? dateOfBirth,
    String? avatarUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['documentID'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  dateOfBirth: const TimestampConverter().fromJson(
    json['dateOfBirth'] as Timestamp,
  ),
  avatarUrl: json['avatar'] as String,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'documentID': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'gender': _$GenderEnumMap[instance.gender]!,
  'dateOfBirth': const TimestampConverter().toJson(instance.dateOfBirth),
  'avatar': instance.avatarUrl,
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.unknown: '',
  Gender.other: 'other',
};

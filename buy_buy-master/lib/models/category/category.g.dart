// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['documentID'] as String,
  name: json['name'] as String,
  iconData: const IconConverter().fromJson((json['iconCode'] as num).toInt()),
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'documentID': instance.id,
  'name': instance.name,
  'iconCode': const IconConverter().toJson(instance.iconData),
};

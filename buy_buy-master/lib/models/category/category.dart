import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

class IconConverter extends JsonConverter<IconData, int> {
  const IconConverter();

  @override
  IconData fromJson(int json) {
    return IconData(json, fontFamily: 'MaterialIcons');
  }

  @override
  int toJson(IconData icon) {
    return icon.codePoint;
  }
}

@JsonSerializable()
class Category {
  @JsonKey(name: 'documentID')
  final String id;

  final String name;

  @IconConverter()
  @JsonKey(name: 'iconCode')
  final IconData iconData;

  Category({required this.id, required this.name, required this.iconData});

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

final allCategory = Category(id: '_all', name: 'All', iconData: Icons.widgets_outlined);

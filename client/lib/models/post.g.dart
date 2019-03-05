// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
      json['name'] as String,
      json['description'] as String,
      json['image'] as String,
      (json['tags'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'tags': instance.tags
    };

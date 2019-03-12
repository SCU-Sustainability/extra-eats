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
      (json['tags'] as List)?.map((e) => e as String)?.toList(),
      json['location'] as String,
      json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      json['creator'] as String,
      json['_id'] as String);
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'location': instance.location,
      'creator': instance.creator,
      '_id': instance.id,
      'expiration': instance.expiration?.toIso8601String(),
      'tags': instance.tags
    };

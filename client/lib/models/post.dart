import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

@JsonSerializable()
class Post {
  Post(this.name, this.description, this.image, this.tags, this.location,
      this.expiration, this.creator, this.id);

  String name;
  String description;
  String image;
  String location;
  String creator;
  @JsonKey(name: '_id')
  String id;
  DateTime expiration;
  List<String> tags;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

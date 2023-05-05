import 'package:cui_messenger/feed/model/comment.dart';

class Post {
  late String postId;
  // late String title;
  late String description;
  late String userImage;
  late String? imageUrl;
  late String fullName;
  // bool like;
  late String createdAt;
  late String uId;
  // late List<Comment> comments;

  Post({
    required this.uId,
    required this.postId,
    // required this.title,
    required this.description,
    required this.userImage,
    required this.imageUrl,
    // required this.like,
    required this.fullName,
    required this.createdAt,
    // required this.comments,
  });

  Post.fromJson(Map<String, dynamic> json) {
    // List<dynamic> commentJson = json['comments'];
    // List<Comment>=
    uId = json['uid'];
    postId = json['post-id'];
    // title = json['title'];
    description = json['description'];
    imageUrl = json['image-url'] ?? "";
    fullName = json['full-name'];
    userImage = json['user-image'];
    // message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post-id'] = postId;
    data['uid'] = uId;
    data['user-image'] = userImage;
    // data['title'] = title;
    data['description'] = description;
    data['full-name'] = fullName;
    data['image-url'] = imageUrl ?? "";
    data['createdAt'] = createdAt;

    return data;
  }
}

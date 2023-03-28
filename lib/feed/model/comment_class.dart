import 'package:flutter/material.dart';

class Comment with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String userImage;
  final bool like;
  final bool dislike;

  Comment(
      {required this.id,
      required this.title,
      required this.description,
      required this.userImage,
      required this.like,
      required this.dislike});
}

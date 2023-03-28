import 'package:flutter/material.dart';

class Post with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String userImage;
  final String imageUrl;
  bool like;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.userImage,
    required this.imageUrl,
    required this.like,
  });
}

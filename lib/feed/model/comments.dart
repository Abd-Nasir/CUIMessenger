import 'package:flutter/material.dart';

import 'package:cui_messenger/feed/model/comment_class.dart';

class Comments with ChangeNotifier {
  List<Comment> comments = [
    Comment(
      id: 'FA19-BSE-089',
      title: 'Noor Fatima',
      description:
          'A comment is a remark or observation that expresses a person observation or criticism. To comment is to make a remark.',
      userImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
      like: false,
      dislike: false,
    ),
    Comment(
      id: 'FA19-BSE-088',
      title: 'Abdullah Nasir',
      description:
          'A comment is a remark or observation that expresses a person observation or criticism. To comment is to make a remark.',
      userImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
      like: false,
      dislike: false,
    ),
    Comment(
      id: 'FA19-BSE-088',
      title: 'Abdullah Nasir',
      description:
          'A comment is a remark or observation that expresses a person observation or criticism. To comment is to make a remark.',
      userImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
      like: false,
      dislike: false,
    ),
    Comment(
      id: 'FA19-BSE-089',
      title: 'Noor Fatima',
      description:
          'A comment is a remark or observation that expresses a person observation or criticism. To comment is to make a remark.',
      userImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
      like: false,
      dislike: false,
    ),
  ];
}

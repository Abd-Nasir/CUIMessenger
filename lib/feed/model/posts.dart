import 'package:cui_messenger/feed/model/post_class.dart';
import 'package:flutter/material.dart';

class Posts with ChangeNotifier {
  List<Post> posts = [
    Post(
        id: 'FA19-BSE-089',
        title: 'Noor Fatima',
        description: 'Hello, this is my first post',
        userImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
        imageUrl:
            'https://whenwherehow.pk/wp-content/uploads/2020/11/Islamabad-COMSATS-New-Library-MAY-2012-01.jpg',
        like: false),
    Post(
        id: 'FA19-BSE-089',
        title: 'Noor Fatima',
        description: 'Hello, this is my first post',
        userImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
        imageUrl: '',
        like: false),
    Post(
        id: 'FA19-BSE-089',
        title: 'Noor Fatima',
        description: 'Hello, this is my first post',
        userImage:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXSTblEVkkdJh15jlAbC3FpvuzCKb1o-pQQA&usqp=CAU',
        imageUrl:
            'https://whenwherehow.pk/wp-content/uploads/2020/11/Islamabad-COMSATS-New-Library-MAY-2012-01.jpg',
        like: false)
  ];

  // @override
  //notifyListeners();
}

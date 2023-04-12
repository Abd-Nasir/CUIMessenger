import 'package:cui_messenger/feed/model/post.dart';

class PostEvents {
  const PostEvents();
}

class LoadReportsEvent extends PostEvents {
  const LoadReportsEvent() : super();
}

class AddPostEvent extends PostEvents {
  final Post post;
  final String userid;
  const AddPostEvent({required this.post, required this.userid}) : super();
}

class LoadPostsFromDatabase extends PostEvents {
  // final String uid;
  const LoadPostsFromDatabase() : super();
}

class LoadPostsDetailPage extends PostEvents {
  const LoadPostsDetailPage() : super();
}

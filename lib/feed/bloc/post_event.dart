import 'package:cui_messenger/feed/model/post.dart';
import 'package:image_picker/image_picker.dart';

class PostEvents {
  const PostEvents();
}

class LoadReportsEvent extends PostEvents {
  const LoadReportsEvent() : super();
}

class AddPostEvent extends PostEvents {
  final Post post;
  final XFile? file;
  const AddPostEvent({required this.post, required this.file}) : super();
}

class LoadPostsFromDatabase extends PostEvents {
  // final String uid;
  const LoadPostsFromDatabase() : super();
}

class LoadPostsDetailPage extends PostEvents {
  const LoadPostsDetailPage() : super();
}

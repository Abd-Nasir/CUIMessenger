import 'package:cui_messenger/feed/bloc/post_event.dart';
import 'package:cui_messenger/feed/bloc/post_provider.dart';
import 'package:cui_messenger/feed/bloc/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvents, PostState> {
  PostBloc(PostProvider postProvider)
      : super(PostState(postProvider: postProvider)) {
    on<LoadPostsFromDatabase>((event, emit) {
      emit(PostStateLoading(postProvider: postProvider));
      postProvider.loadData();
      emit(PostState(postProvider: postProvider));
    });

    on<AddPostEvent>((event, emit) async {
      emit(PostStateLoading(postProvider: postProvider));
      bool res = await postProvider.saveReport(event.post, event.file);
      if (res) {
        emit(PostStateSaveSuccess(postProvider: postProvider));
      } else {
        emit(PostStateSaveFailed(postProvider: postProvider));
      }
    });
  }
}

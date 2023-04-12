import 'package:cui_messenger/feed/bloc/post_provider.dart';
import 'package:equatable/equatable.dart';

class PostState extends Equatable {
  final PostProvider postProvider;

  const PostState({required this.postProvider});

  PostState copyWith({PostProvider? postProvider}) =>
      PostState(postProvider: postProvider ?? this.postProvider);

  @override
  List<Object?> get props => [postProvider];
}

class PostStateLoading extends PostState {
  const PostStateLoading({required super.postProvider});
}

class PostStateSaveSuccess extends PostState {
  const PostStateSaveSuccess({required super.postProvider});
}

class PostStateSaveFailed extends PostState {
  const PostStateSaveFailed({required super.postProvider});
}

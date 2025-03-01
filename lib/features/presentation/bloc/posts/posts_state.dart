part of 'posts_bloc.dart';

@immutable
abstract class PostsState extends BaseState<PostsState> {}

class PostsInitial extends PostsState {}

class GetAllCommentsSuccessState extends PostsState {
  final List<CommentsResponse> comments;

  GetAllCommentsSuccessState({
    required this.comments,
  });
}

class GetAllOrganizersSuccessState extends PostsState {
  final List<EventOrganizersResponse> organizers;

  GetAllOrganizersSuccessState({
    required this.organizers,
  });
}

class GetAllImagesSuccessState extends PostsState {
  final List<ImageSliderResponse> images;

  GetAllImagesSuccessState({
    required this.images,
  });
}

class GetAllPostsSuccessState extends PostsState {
  final List<PostsResponse> posts;

  GetAllPostsSuccessState({
    required this.posts,
  });
}

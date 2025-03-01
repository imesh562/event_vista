part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent extends BaseEvent {}

class GetAllCommentsEvent extends PostsEvent {}

class GetAllOrganizersEvent extends PostsEvent {}

class GetAllImagesEvent extends PostsEvent {}

class GetAllPostsEvent extends PostsEvent {}

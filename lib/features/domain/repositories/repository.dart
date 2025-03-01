import 'package:dartz/dartz.dart';
import 'package:eventvista/features/data/models/responses/comments_response.dart';
import 'package:eventvista/features/data/models/responses/event_organizers_response.dart';
import 'package:eventvista/features/data/models/responses/image_slider_response.dart';
import 'package:eventvista/features/data/models/responses/posts_response.dart';

import '../../../error/failures.dart';

abstract class Repository {
  Future<Either<Failure, List<CommentsResponse>>> commentsAPI();
  Future<Either<Failure, List<EventOrganizersResponse>>> eventOrganizersAPI();
  Future<Either<Failure, List<ImageSliderResponse>>> imageSliderAPI();
  Future<Either<Failure, List<PostsResponse>>> postsAPI();
}

import 'dart:async';

import 'package:bloc/src/bloc.dart';
import 'package:eventvista/features/data/datasources/shared_preference.dart';
import 'package:eventvista/features/domain/repositories/repository.dart';
import 'package:eventvista/utils/device_info.dart';
import 'package:meta/meta.dart';

import '../../../../error/failures.dart';
import '../../../../error/messages.dart';
import '../../../data/models/common/common_error_response.dart';
import '../../../data/models/responses/comments_response.dart';
import '../../../data/models/responses/event_organizers_response.dart';
import '../../../data/models/responses/image_slider_response.dart';
import '../../../data/models/responses/posts_response.dart';
import '../base_bloc.dart';
import '../base_event.dart';
import '../base_state.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Base<PostsEvent, BaseState<PostsState>> {
  final AppSharedData appSharedData;
  final Repository repository;
  final DeviceInfo deviceInfo;

  PostsBloc({
    required this.appSharedData,
    required this.repository,
    required this.deviceInfo,
  }) : super(PostsInitial()) {
    on<GetAllCommentsEvent>(_getAllComments);
    on<GetAllOrganizersEvent>(_getAllOrganizers);
    on<GetAllImagesEvent>(_getAllImages);
    on<GetAllPostsEvent>(_getAllPosts);
  }

  Future<void> _getAllComments(
      GetAllCommentsEvent event, Emitter<BaseState<PostsState>> emit) async {
    emit(APILoadingState());
    final result = await repository.commentsAPI();
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(errorResponseModel: l.errorResponse);
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.isNotEmpty) {
        return GetAllCommentsSuccessState(
          comments: r,
        );
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }));
  }

  Future<void> _getAllOrganizers(
      GetAllOrganizersEvent event, Emitter<BaseState<PostsState>> emit) async {
    emit(APILoadingState());
    final result = await repository.eventOrganizersAPI();
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(errorResponseModel: l.errorResponse);
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.isNotEmpty) {
        return GetAllOrganizersSuccessState(
          organizers: r,
        );
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }));
  }

  Future<void> _getAllPosts(
      GetAllPostsEvent event, Emitter<BaseState<PostsState>> emit) async {
    emit(APILoadingState());
    final result = await repository.postsAPI();
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(errorResponseModel: l.errorResponse);
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.isNotEmpty) {
        return GetAllPostsSuccessState(
          posts: r,
        );
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }));
  }

  Future<void> _getAllImages(
      GetAllImagesEvent event, Emitter<BaseState<PostsState>> emit) async {
    emit(APILoadingState());
    final result = await repository.imageSliderAPI();
    emit(result.fold((l) {
      if (l is ServerFailure) {
        return APIFailureState(errorResponseModel: l.errorResponse);
      } else if (l is AuthorizedFailure) {
        return AuthorizedFailureState(errorResponseModel: l.errorResponse);
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }, (r) {
      if (r.isNotEmpty) {
        return GetAllImagesSuccessState(
          images: r,
        );
      } else {
        return APIFailureState(
            errorResponseModel: ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''));
      }
    }));
  }
}

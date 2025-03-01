import 'package:dartz/dartz.dart';
import 'package:eventvista/error/failures.dart';
import 'package:eventvista/features/data/models/responses/comments_response.dart';
import 'package:eventvista/features/data/models/responses/event_organizers_response.dart';
import 'package:eventvista/features/data/models/responses/image_slider_response.dart';
import 'package:eventvista/features/data/models/responses/posts_response.dart';

import '../../../core/network/network_info.dart';
import '../../../error/exceptions.dart';
import '../../../error/messages.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/common/common_error_response.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CommentsResponse>>> commentsAPI() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.commentsAPI();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on MaintenanceException catch (e) {
        return Left(MaintenanceFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<EventOrganizersResponse>>>
      eventOrganizersAPI() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.eventOrganizersAPI();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on MaintenanceException catch (e) {
        return Left(MaintenanceFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<ImageSliderResponse>>> imageSliderAPI() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.imageSliderAPI();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on MaintenanceException catch (e) {
        return Left(MaintenanceFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<PostsResponse>>> postsAPI() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.postsAPI();
        return Right(response);
      } on ServerException catch (ex) {
        return Left(ServerFailure(ex.errorResponseModel));
      } on UnAuthorizedException catch (ex) {
        return Left(AuthorizedFailure(ex.errorResponseModel));
      } on DioException catch (e) {
        return Left(ServerFailure(e.errorResponseModel));
      } on MaintenanceException catch (e) {
        return Left(MaintenanceFailure(e.errorResponseModel));
      } on Exception {
        return Left(
          ServerFailure(
            ErrorResponseModel(
                responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                responseCode: ''),
          ),
        );
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}

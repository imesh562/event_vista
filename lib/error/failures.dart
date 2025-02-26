import 'package:equatable/equatable.dart';

import '../features/data/models/common/common_error_response.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => props;
}

// General failures
class ServerFailure extends Failure {
  final ErrorResponseModel errorResponse;

  ServerFailure(this.errorResponse);
}

class CacheFailure extends Failure {}

class ConnectionFailure extends Failure {}

class AuthorizedFailure extends Failure {
  final ErrorResponseModel errorResponse;

  AuthorizedFailure(this.errorResponse);
}

class MaintenanceFailure extends Failure {
  final ErrorResponseModel errorResponse;

  MaintenanceFailure(this.errorResponse);
}

class ForceUpdateFailure extends Failure {
  final ErrorResponseModel errorResponse;

  ForceUpdateFailure(this.errorResponse);
}

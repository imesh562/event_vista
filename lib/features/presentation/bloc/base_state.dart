import '../../data/models/common/common_error_response.dart';

abstract class BaseState<K> {
  const BaseState();
}

class BaseInitial extends BaseState {}

class APIFailureState<K> extends BaseState<K> {
  final ErrorResponseModel errorResponseModel;

  APIFailureState({required this.errorResponseModel});
}

class AuthorizedFailureState<K> extends BaseState<K> {
  final ErrorResponseModel errorResponseModel;
  final bool isSplash;

  AuthorizedFailureState({
    required this.errorResponseModel,
    this.isSplash = false,
  });
}

class APILoadingState<K> extends BaseState<K> {}

class MaintenanceState<K> extends BaseState<K> {
  final ErrorResponseModel errorResponseModel;

  MaintenanceState({required this.errorResponseModel});
}

class ForceUpdateState<K> extends BaseState<K> {
  final ErrorResponseModel errorResponseModel;

  ForceUpdateState({required this.errorResponseModel});
}

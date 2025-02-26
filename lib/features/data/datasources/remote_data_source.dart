import 'dart:core';

import 'package:eventvista/core/network/api_helper.dart';
import 'package:eventvista/core/network/mock_api_helper.dart';
import 'package:eventvista/features/data/datasources/shared_preference.dart';

abstract class RemoteDataSource {}

class RemoteDataSourceImpl implements RemoteDataSource {
  final APIHelper apiHelper;
  final MockAPIHelper mockAPIHelper;
  final AppSharedData appSharedData;

  RemoteDataSourceImpl({
    required this.apiHelper,
    required this.appSharedData,
    required this.mockAPIHelper,
  });
}

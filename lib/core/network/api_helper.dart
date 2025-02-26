import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../error/exceptions.dart' as EXC;
import '../../error/messages.dart';
import '../../features/data/datasources/shared_preference.dart';
import '../../features/data/models/common/common_error_response.dart';
import 'network_config.dart';

class APIHelper {
  final Dio dio;
  final AppSharedData appSharedData;
  final PackageInfo packageInfo;

  APIHelper(
      {required this.dio,
      required this.appSharedData,
      required this.packageInfo}) {
    _initApiClient();
  }

  _initApiClient() {
    final logInterceptor = LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      error: kDebugMode,
      requestHeader: kDebugMode,
      responseHeader: kDebugMode,
    );

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: CONNECT_TIMEOUT),
      receiveTimeout: const Duration(milliseconds: RECEIVE_TIMEOUT),
      baseUrl: NetworkConfig.getNetworkUrl(),
      contentType: 'application/json',
    );

    dio
      ..options = options
      ..interceptors.add(logInterceptor);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  Future<dynamic> get(String url) async {
    try {
      if (appSharedData.getAppToken() != null) {
        dio.options.headers["Authorization"] =
            "Bearer ${appSharedData.getAppToken() ?? ''}";
      }

      dio.options.headers["type"] = Platform.isAndroid ? "ANDROID" : "IOS";
      dio.options.headers["version_no"] = packageInfo.buildNumber;

      final response = await dio.get(
        NetworkConfig.getNetworkUrl() + url,
      );
      log(response.toString());
      return response;
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != null) {
        final int statusCode = e.response!.statusCode!;
        if (statusCode < 200 || statusCode >= 400) {
          switch (statusCode) {
            case 400:
              throw EXC.ServerException(ErrorResponseModel(
                  responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                  responseCode: ''));
            case 401:
            case 403:
              throw EXC.UnAuthorizedException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 404:
              throw EXC.ServerException(ErrorResponseModel(
                  responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                  responseCode: ''));
            case 426:
              throw EXC.ForceUpdateException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 500:
              throw EXC.ServerException(ErrorResponseModel(
                  responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
                  responseCode: ''));
            case 503:
              throw EXC.MaintenanceException(
                  ErrorResponseModel.fromJson(e.response!.data));
            default:
              throw EXC.DioException(
                  errorResponseModel: ErrorResponseModel(
                      responseCode: e.response!.statusCode.toString(),
                      responseError: e.response!.statusMessage!));
          }
        }
      } else {
        throw EXC.ServerException(ErrorResponseModel(
            responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
            responseCode: ''));
      }
    }
  }

  Future<dynamic> post(String url, {@required body}) async {
    try {
      if (appSharedData.getAppToken() != null) {
        dio.options.headers["Authorization"] =
            "Bearer ${appSharedData.getAppToken() ?? ''}";
      }

      dio.options.headers["type"] = Platform.isAndroid ? "ANDROID" : "IOS";
      dio.options.headers["version_no"] = packageInfo.buildNumber;

      final response = await dio.post(
        NetworkConfig.getNetworkUrl() + url,
        data: body,
      );
      log(response.toString());
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        final int statusCode = e.response!.statusCode!;

        if (statusCode < 200 || statusCode >= 400) {
          switch (statusCode) {
            case 400:
              throw EXC.ServerException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 401:
            case 403:
              throw EXC.UnAuthorizedException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 404:
              throw EXC.ServerException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 426:
              throw EXC.ForceUpdateException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 500:
              throw EXC.ServerException(
                  ErrorResponseModel.fromJson(e.response!.data));
            case 503:
              throw EXC.MaintenanceException(
                  ErrorResponseModel.fromJson(e.response!.data));
            default:
              throw EXC.DioException(
                  errorResponseModel: ErrorResponseModel(
                      responseCode: e.response!.statusCode.toString(),
                      responseError: e.response!.statusMessage!));
          }
        } else {
          throw EXC.ServerException(ErrorResponseModel(
              responseError: e.response!.data['message'], responseCode: ''));
        }
      } else {
        throw EXC.ServerException(ErrorResponseModel(
            responseError: ErrorMessages.ERROR_SOMETHING_WENT_WRONG,
            responseCode: ''));
      }
    }
  }
}

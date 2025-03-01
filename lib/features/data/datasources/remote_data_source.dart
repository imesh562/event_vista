import 'dart:convert';
import 'dart:core';

import 'package:eventvista/core/network/api_helper.dart';
import 'package:eventvista/core/network/mock_api_helper.dart';
import 'package:eventvista/features/data/datasources/shared_preference.dart';
import 'package:eventvista/features/data/models/responses/comments_response.dart';
import 'package:eventvista/features/data/models/responses/event_organizers_response.dart';
import 'package:eventvista/features/data/models/responses/image_slider_response.dart';
import 'package:eventvista/features/data/models/responses/posts_response.dart';

abstract class RemoteDataSource {
  Future<List<ImageSliderResponse>> imageSliderAPI();
  Future<List<EventOrganizersResponse>> eventOrganizersAPI();
  Future<List<PostsResponse>> postsAPI();
  Future<List<CommentsResponse>> commentsAPI();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final APIHelper apiHelper;
  final MockAPIHelper mockAPIHelper;
  final AppSharedData appSharedData;

  RemoteDataSourceImpl({
    required this.apiHelper,
    required this.appSharedData,
    required this.mockAPIHelper,
  });

  @override
  Future<List<ImageSliderResponse>> imageSliderAPI() async {
    try {
      final response = await apiHelper.get(
        "photos",
      );
      return imageSliderResponseFromJson(jsonEncode(response.data));
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<CommentsResponse>> commentsAPI() async {
    try {
      final response = await apiHelper.get(
        "comments",
      );
      return commentsResponseFromJson(jsonEncode(response.data));
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<EventOrganizersResponse>> eventOrganizersAPI() async {
    try {
      final response = await apiHelper.get(
        "users",
      );
      return eventOrganizersResponseFromJson(jsonEncode(response.data));
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<PostsResponse>> postsAPI() async {
    try {
      final response = await apiHelper.get(
        "posts",
      );
      return postsResponseFromJson(jsonEncode(response.data));
    } on Exception {
      rethrow;
    }
  }
}

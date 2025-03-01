import 'package:eventvista/features/data/models/responses/comments_response.dart';
import 'package:eventvista/features/data/models/responses/posts_response.dart';
import 'package:eventvista/features/presentation/bloc/posts/posts_bloc.dart';
import 'package:eventvista/features/presentation/views/posts/common/post_widget.dart';
import 'package:eventvista/utils/app_colors.dart';
import 'package:eventvista/utils/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/appbar.dart';
import '../base_view.dart';
import 'common/comment_widget.dart';

class PostsView extends BaseView {
  final List<PostsResponse> posts;

  PostsView({super.key, required this.posts});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends BaseViewState<PostsView> {
  final PostsBloc bloc = injection<PostsBloc>();
  List<CommentsResponse> comments = [];
  int? selectedPostId;

  @override
  void initState() {
    super.initState();
    bloc.add(GetAllCommentsEvent());
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<PostsBloc>(
      create: (_) => bloc,
      child: BlocListener<PostsBloc, BaseState<PostsState>>(
        listener: (_, state) {
          if (state is GetAllCommentsSuccessState) {
            setState(() {
              comments.clear();
              comments.addAll(state.comments);
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.initColors().white,
          appBar: EventVistaAppBar(
            title: 'Posts',
            showDivider: true,
          ),
          body: widget.posts.isEmpty
              ? _buildEmptyPostsView()
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: widget.posts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final post = widget.posts[index];
                    return PostWidget(
                      post: post,
                      onTap: () => _showCommentsBottomSheet(context, post.id),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyPostsView() {
    return Center(
      child: Text(
        'No posts available',
        style: TextStyle(
          fontSize: AppDimensions.kFontSize16,
          fontWeight: FontWeight.w500,
          color: AppColors.initColors().blackTextColor1,
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, int? postId) {
    if (postId == null) return;

    setState(() {
      selectedPostId = postId;
    });

    final postComments =
        comments.where((comment) => comment.postId == postId).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Bottom sheet handle
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.initColors().greyTextColor1,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments (${postComments.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimensions.kFontSize18,
                          color: AppColors.initColors().blackTextColor1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20.sp,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Comments list or empty state
                Expanded(
                  child: postComments.isEmpty
                      ? _buildEmptyCommentsView()
                      : ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.all(16.w),
                          itemCount: postComments.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final comment = postComments[index];
                            return CommentWidget(comment: comment);
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCommentsView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.comment_bank_outlined,
            size: 48.sp,
            color: AppColors.initColors().greyTextColor1,
          ),
          SizedBox(height: 16.h),
          Text(
            'No comments for this post',
            style: TextStyle(
              fontSize: AppDimensions.kFontSize16,
              color: AppColors.initColors().greyTextColor1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

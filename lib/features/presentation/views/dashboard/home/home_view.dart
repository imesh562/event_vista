import 'package:eventvista/features/presentation/views/dashboard/home/common/home_slider_widget.dart';
import 'package:eventvista/utils/app_dimensions.dart';
import 'package:eventvista/utils/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../data/models/responses/event_organizers_response.dart';
import '../../../../data/models/responses/image_slider_response.dart';
import '../../../../data/models/responses/posts_response.dart';
import '../../../bloc/base_bloc.dart';
import '../../../bloc/base_event.dart';
import '../../../bloc/base_state.dart';
import '../../../bloc/posts/posts_bloc.dart';
import '../../base_view.dart';
import 'common/organizers_widget.dart';
import 'common/post_widget.dart';

class HomeView extends BaseView {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseViewState<HomeView> {
  var bloc = injection<PostsBloc>();
  List<ImageSliderResponse> images = [];
  List<EventOrganizersResponse> organizers = [];
  List<PostsResponse> posts = [];

  @override
  void initState() {
    super.initState();
    bloc.add(GetAllImagesEvent());
    bloc.add(GetAllPostsEvent());
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<PostsBloc>(
      create: (_) => bloc,
      child: BlocListener<PostsBloc, BaseState<PostsState>>(
        listener: (_, state) {
          if (state is GetAllImagesSuccessState) {
            bloc.add(GetAllOrganizersEvent());
            setState(() {
              images.clear();
              images.addAll(state.images);
            });
          } else if (state is GetAllOrganizersSuccessState) {
            setState(() {
              organizers.clear();
              organizers.addAll(state.organizers);
            });
          } else if (state is GetAllPostsSuccessState) {
            setState(() {
              posts.clear();
              posts.addAll(state.posts);
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.initColors().white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Slider
                images.isNotEmpty
                    ? HomeSliderWidget(images: images)
                    : const SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Name',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.initColors().blackTextColor1,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "56 O'Mally Road, ST LEONARDS, 2065, NSW",
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.initColors().greyTextColor1,
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Text(
                        'Organizers',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.initColors().blackTextColor1,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      organizers.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: organizers.length,
                              itemBuilder: (context, index) {
                                return OrganizersWidget(
                                  name: organizers[index].name ?? '',
                                  email: organizers[index].email ?? '',
                                  imageUrl: organizers[index].website ?? '',
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Photos',
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.initColors().blackTextColor1,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'All Photos',
                                style: TextStyle(
                                  fontSize: AppDimensions.kFontSize14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.initColors().primaryOrange,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.initColors().primaryOrange,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                images.isNotEmpty
                    ? SizedBox(
                        height: 300.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(left: 16.w)
                                  : EdgeInsets.zero,
                              child: PostWidget(
                                title: images[index].title ?? '',
                                imageUrl: images[index].thumbnailUrl ?? '',
                                content:
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: 13.h),
                if (posts.isNotEmpty)
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.kPostsView,
                        arguments: posts,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              posts.length.toString(),
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize19,
                                fontWeight: FontWeight.w600,
                                color: AppColors.initColors().primaryOrange,
                              ),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.initColors().greyTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 13.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

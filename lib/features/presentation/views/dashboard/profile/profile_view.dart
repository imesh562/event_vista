import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/navigation_routes.dart';
import '../../../bloc/base_bloc.dart';
import '../../../bloc/base_event.dart';
import '../../../bloc/base_state.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../base_view.dart';
import 'common/profile_drawer.dart';

class ProfileView extends BaseView {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends BaseViewState<ProfileView> {
  var bloc = injection<AuthBloc>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PackageInfo? _packageInfo;
  User? user;
  Map<String, dynamic>? userData;
  final _emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    _loadPackageInfo();
    super.initState();
    bloc.add(FetchUserProfileEvent());
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => bloc,
      child: BlocListener<AuthBloc, BaseState<AuthState>>(
        listener: (_, state) {
          if (state is ProfileLoaded) {
            setState(() {
              user = state.user;
              userData = state.userData;
              populateControllers();
            });
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.initColors().white,
          appBar: AppBar(
            title: Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppDimensions.kFontSize17,
                color: AppColors.initColors().blackTextColor1,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.initColors().white,
            elevation: 0,
            leading: userData != null && user != null
                ? Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: CircleAvatar(
                        radius: 22.w,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.file(
                            userData!['profilePic'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Image.asset(
                                AppImages.icCamera,
                                height: 10.h,
                                width: 10.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Divider(
                color: AppColors.initColors().dividerColor2,
                height: 1.h,
              ),
            ),
          ),
          drawer: userData != null && user != null
              ? ProfileDrawer(
                  userData: userData,
                  bloc: bloc,
                  packageInfo: _packageInfo,
                )
              : const SizedBox.shrink(),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: userData != null && user != null
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 24.h),
                                ClipOval(
                                  child: Container(
                                    width: 116.w,
                                    height: 116.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.initColors()
                                          .profilePicBgColor,
                                    ),
                                    child: Image.file(
                                      userData!['profilePic'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Image.asset(
                                          AppImages.icCamera,
                                          height: 24.h,
                                          width: 24.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                Column(
                                  children: [
                                    AppTextField(
                                      label: 'First Name',
                                      controller: firstNameController,
                                      isEnable: false,
                                    ),
                                    SizedBox(height: 24.h),
                                    AppTextField(
                                      label: 'Last Name',
                                      controller: lastNameController,
                                      isEnable: false,
                                    ),
                                    SizedBox(height: 24.h),
                                    AppTextField(
                                      label: 'Email',
                                      controller: _emailController,
                                      isEnable: false,
                                    ),
                                    SizedBox(height: 24.h),
                                    AppTextField(
                                      label: 'Phone number',
                                      controller: phoneNumberController,
                                      isEnable: false,
                                    ),
                                    SizedBox(height: 24.h),
                                    AppTextField(
                                      label: 'Mailing address',
                                      controller: addressController,
                                      isEnable: false,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
                        ),
                        AppButton(
                          buttonText: 'Edit',
                          onTapButton: () {
                            Navigator.pushNamed(
                                    context, Routes.kEditProfileView)
                                .then((value) {
                              if (value != null && value is bool && value) {
                                bloc.add(FetchUserProfileEvent());
                              }
                            });
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    )
                  : const SizedBox.shrink()),
        ),
      ),
    );
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  void populateControllers() {
    if (userData != null) {
      if (userData!.containsKey('email')) {
        _emailController.text = userData!['email'] ?? '';
      }

      if (userData!.containsKey('firstName')) {
        firstNameController.text = userData!['firstName'] ?? '';
      }

      if (userData!.containsKey('lastName')) {
        lastNameController.text = userData!['lastName'] ?? '';
      }

      if (userData!.containsKey('phoneNumber')) {
        phoneNumberController.text = userData!['phoneNumber'] ?? '';
      }

      if (userData!.containsKey('mailingAddress')) {
        addressController.text = userData!['mailingAddress'] ?? '';
      }
    }
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

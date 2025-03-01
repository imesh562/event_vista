import 'package:email_validator/email_validator.dart';
import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/navigation_routes.dart';
import '../../../bloc/base_bloc.dart';
import '../../../bloc/base_event.dart';
import '../../../bloc/base_state.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';
import '../../base_view.dart';

class ProfileView extends BaseView {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends BaseViewState<ProfileView> {
  var bloc = injection<AuthBloc>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PackageInfo? _packageInfo;
  String? imageUrl;

  @override
  void initState() {
    _loadPackageInfo();
    super.initState();
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
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
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: CircleAvatar(
              radius: 22.w,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(
            color: AppColors.initColors().dividerColor2,
            height: 1.h,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 52.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22.w,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jane Cooper',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppDimensions.kFontSize16,
                                  color: AppColors.initColors().blackTextColor1,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'jane.c@gmail.com',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppDimensions.kFontSize14,
                                  color: AppColors.initColors().greyTextColor1,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Divider(
                    color: AppColors.initColors().dividerColor2,
                    height: 1.h,
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.kLoginView, (route) => false);
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 16.w),
                        Image.asset(
                          AppImages.icLogout,
                          height: 20.h,
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.kFontSize14,
                            color: AppColors.initColors().logoutColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (_packageInfo != null)
              Text(
                'Version ${_packageInfo!.version}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimensions.kFontSize14,
                  color: AppColors.initColors().greyTextColor1,
                ),
              ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
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
                          color: AppColors.initColors().profilePicBgColor,
                        ),
                        child: (imageUrl != null && imageUrl!.isNotEmpty)
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                  child: Image.asset(
                                    AppImages.icCamera,
                                    height: 24.h,
                                    width: 24.h,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Column(
                      children: [
                        AppTextField(
                          label: 'First Name',
                          hint: 'Enter First Name',
                          filterType: FilterType.TYPE6,
                          isEnable: false,
                          maxLength: 60,
                          textInputFormatter:
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          inputType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First Name required!';
                            } else if (value.length < 3) {
                              return 'First name is invalid!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        AppTextField(
                          label: 'Last Name',
                          hint: 'Enter Last Name',
                          filterType: FilterType.TYPE6,
                          isEnable: false,
                          maxLength: 60,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Last Name required!';
                            } else {
                              if (value.length < 3) {
                                return 'Last name is invalid!';
                              } else if (RegExp(r"\s{2,}").hasMatch(value)) {
                                return 'Last name is invalid!';
                              } else if (value.split(' ').length > 2) {
                                return 'Only two words are allowed';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        AppTextField(
                          label: 'Email',
                          hint: 'Enter your email',
                          isEnable: false,
                          maxLines: 1,
                          maxLength: 100,
                          inputType: TextInputType.emailAddress,
                          textInputFormatter: FilteringTextInputFormatter.deny(
                              RegExp(r'[^\w.@+-]')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required!";
                            } else if (!EmailValidator.validate(value)) {
                              return "Email is invalid!";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        AppTextField(
                          label: 'Phone number',
                          hint: 'Enter Phone number',
                          isEnable: false,
                          filterType: FilterType.TYPE4,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number is required!";
                            } else {
                              if (value.replaceAll(' ', '').length < 6) {
                                return 'Phone number is invalid!';
                              }
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),
                        AppTextField(
                          label: 'Mailing address',
                          hint: 'Enter Mailing address',
                          isEnable: false,
                          maxLength: 255,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mailing address is required!";
                            } else {
                              if (RegExp(r"\s{2,}").hasMatch(value)) {
                                return 'Invalid Mailing address';
                              }
                            }
                            return null;
                          },
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
                Navigator.pushNamed(context, Routes.kEditView);
              },
            ),
            SizedBox(height: 24.h),
          ],
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

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

import 'dart:io';

import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:eventvista/utils/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/service/app_permission.dart';
import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/enums.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/app_button.dart';
import '../base_view.dart';

class ProfilePictureUploadView extends BaseView {
  ProfilePictureUploadView({super.key});

  @override
  State<ProfilePictureUploadView> createState() =>
      _ProfilePictureUploadViewState();
}

class _ProfilePictureUploadViewState
    extends BaseViewState<ProfilePictureUploadView> {
  var bloc = injection<AuthBloc>();
  CroppedFile? selectedPicture;

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.initColors().white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppDimensions.kFontSize32,
                      color: AppColors.initColors().blackTextColor1,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      'You are logged in for the first time and can upload a profile photo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppDimensions.kFontSize14,
                        color: AppColors.initColors().greyTextColor1,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  InkWell(
                    onTap: _showImagePicker,
                    child: ClipOval(
                      child: Container(
                        width: 116.w,
                        height: 116.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.initColors().profilePicBgColor,
                        ),
                        child: selectedPicture != null
                            ? Image.file(
                                File(selectedPicture!.path),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Image.asset(
                                  AppImages.icCamera,
                                  height: 24.h,
                                  width: 24.h,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              buttonText: 'Next',
              onTapButton: () {
                if (selectedPicture != null) {
                  Navigator.pushNamed(context, Routes.kCompleteProfileView);
                }
              },
              prefixIcon: Image.asset(
                AppImages.icNext,
                height: 20.h,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Future<void> _showImagePicker() async {
    showCustomDialog(
      Column(
        children: [
          IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 4.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: AppColors.initColors().colorImagePlaceholder,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'Change Profile Picture',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.initColors().primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                InkWell(
                  onTap: () {
                    getImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.icGallery,
                        height: 32.h,
                        color: AppColors.initColors().primaryOrange,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Choose from Gallery',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.initColors().blackTextColor1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 37.h),
                InkWell(
                  onTap: () {
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.icCamera,
                        height: 32.h,
                        color: AppColors.initColors().primaryOrange,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Take a picture',
                        style: TextStyle(
                          fontSize: AppDimensions.kFontSize14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.initColors().blackTextColor1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getImageFromCamera() async {
    AppPermissionManager.requestCameraPermission(context, () async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        final imageCropper = ImageCropper();
        final croppedFile = await imageCropper.cropImage(
          sourcePath: image.path,
          compressQuality: 40,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          cropStyle: CropStyle.rectangle,
        );

        if (croppedFile != null) {
          setState(() {
            selectedPicture = croppedFile;
          });
        }
      } else {
        print('No image selected.');
      }
    }, (error) {
      showSnackBar(error, AlertType.FAIL);
    });
  }

  Future getImageFromGallery() async {
    AppPermissionManager.requestGalleryPermission(context, () async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        final imageCropper = ImageCropper();
        final croppedFile = await imageCropper.cropImage(
          sourcePath: image.path,
          compressQuality: 40,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          cropStyle: CropStyle.rectangle,
        );

        if (croppedFile != null) {
          setState(() {
            selectedPicture = croppedFile;
          });
        }
      } else {
        print('No image selected.');
      }
    }, (error) {
      showSnackBar(error, AlertType.FAIL);
    });
  }

  Future<void> _uploadImage(CroppedFile image) async {
    File imageFile = File(image.path);
    final fileSize = await imageFile.length();
    if (fileSize > 10485760) {
      showSnackBar('Maximum upload size is 10MB.', AlertType.FAIL);
    } else {}
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

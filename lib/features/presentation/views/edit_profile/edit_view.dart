import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/common/appbar.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/navigation_routes.dart';
import '../../../../core/service/app_permission.dart';
import '../../../../utils/app_dimensions.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../base_view.dart';

class EditProfileView extends BaseView {
  EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends BaseViewState<EditProfileView> {
  var bloc = injection<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  String? imageUrl;
  CroppedFile? selectedPicture;

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.initColors().white,
      appBar: EventVistaAppBar(
        title: 'Edit profile',
        showDivider: true,
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
                          child: Stack(
                            children: [
                              selectedPicture != null
                                  ? Image.file(
                                      File(selectedPicture!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      imageUrl ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Image.asset(
                                          AppImages.icCamera,
                                          color: AppColors.initColors().white,
                                          height: 24.h,
                                          width: 24.h,
                                        ),
                                      ),
                                    ),
                              Center(
                                child: Image.asset(
                                  AppImages.icCamera,
                                  color: AppColors.initColors().white,
                                  height: 24.h,
                                  width: 24.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'First Name',
                            hint: 'Enter First Name',
                            filterType: FilterType.TYPE6,
                            controller: firstNameController,
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
                            controller: lastNameController,
                            filterType: FilterType.TYPE6,
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
                            controller: _emailController,
                            maxLines: 1,
                            maxLength: 100,
                            inputType: TextInputType.emailAddress,
                            textInputFormatter:
                                FilteringTextInputFormatter.deny(
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
                            controller: phoneNumberController,
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
                            controller: addressController,
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
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            AppButton(
              buttonText: 'Save',
              onTapButton: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, Routes.kEditProfileView);
                }
              },
            ),
            SizedBox(height: 24.h),
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

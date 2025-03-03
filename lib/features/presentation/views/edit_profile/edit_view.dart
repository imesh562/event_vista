import 'dart:io';

import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/common/appbar.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/enums.dart';
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
  CroppedFile? selectedPicture;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
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
          } else if (state is AuthAuthenticated) {
            if (selectedPicture != null) {
              bloc.add(UploadProfilePictureEvent(
                imageFile: File(selectedPicture!.path),
              ));
            } else {
              Navigator.pop(context, true);
            }
          } else if (state is AuthProfileIncomplete) {
            Navigator.pop(context, true);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.initColors().white,
          appBar: EventVistaAppBar(
            title: 'Edit profile',
            showDivider: true,
          ),
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
                              InkWell(
                                onTap: _showImagePicker,
                                child: ClipOval(
                                  child: Container(
                                    width: 116.w,
                                    height: 116.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.initColors()
                                          .profilePicBgColor,
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          selectedPicture != null
                                              ? File(selectedPicture!.path)
                                              : userData!['profilePic'],
                                          fit: BoxFit.cover,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextField(
                                      label: 'First Name',
                                      hint: 'Enter First Name',
                                      filterType: FilterType.TYPE2,
                                      controller: firstNameController,
                                      maxLength: 10,
                                      textInputFormatter:
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'\s')),
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
                                      filterType: FilterType.TYPE2,
                                      maxLength: 10,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Last Name required!';
                                        } else {
                                          if (value.length < 3) {
                                            return 'Last name is invalid!';
                                          } else if (RegExp(r"\s{2,}")
                                              .hasMatch(value)) {
                                            return 'Last name is invalid!';
                                          } else if (value.split(' ').length >
                                              2) {
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
                                      isEnable: false,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Cannot change the email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: AppDimensions.kFontSize12,
                                        color: AppColors.initColors().dark,
                                      ),
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
                                        }
                                        String cleanedValue =
                                            value.replaceAll(' ', '');
                                        if (cleanedValue.length != 10) {
                                          return 'Phone number must be 10 digits!';
                                        }
                                        if (!RegExp(r'^07\d{8}$')
                                            .hasMatch(cleanedValue)) {
                                          return 'Invalid Sri Lankan phone number!';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                    AppTextField(
                                      label: 'Mailing address',
                                      hint: 'Enter Mailing address',
                                      controller: addressController,
                                      maxLength: 50,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Mailing address is required!";
                                        } else {
                                          if (value.length < 6) {
                                            return 'Mailing address is invalid!';
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
                            bloc.add(UpdateUserProfileEvent(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              mailingAddress: addressController.text,
                              phoneNumber: phoneNumberController.text,
                            ));
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
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

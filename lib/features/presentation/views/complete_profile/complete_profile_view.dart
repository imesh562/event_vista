import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/common/app_button_outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/navigation_routes.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/app_button.dart';
import '../../common/app_text_field.dart';
import '../base_view.dart';

class CompleteProfileView extends BaseView {
  final String email;
  CompleteProfileView({required this.email});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends BaseViewState<CompleteProfileView> {
  var bloc = injection<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => bloc,
      child: BlocListener<AuthBloc, BaseState<AuthState>>(
        listener: (_, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.kDashboardView, (route) => false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.initColors().white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 64.h),
                        Text(
                          'Personal info',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.kFontSize19,
                            color: AppColors.initColors().blackTextColor1,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'You can add your personal data now or do it later',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: AppDimensions.kFontSize14,
                            color: AppColors.initColors().greyTextColor1,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Form(
                          key: formKey,
                          child: Column(
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
                                initialValue: widget.email,
                                maxLines: 1,
                                maxLength: 100,
                                inputType: TextInputType.emailAddress,
                                textInputFormatter:
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[^\w.@+-]')),
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
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButtonOutline(
                        buttonText: 'Back',
                        onTapButton: () {
                          Navigator.pop(context);
                        },
                        suffixIcon: Image.asset(
                          AppImages.icBack,
                          height: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: AppButton(
                        buttonText: 'Next',
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
                        prefixIcon: Image.asset(
                          AppImages.icNext,
                          height: 20.h,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
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

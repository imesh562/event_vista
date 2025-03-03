import 'package:email_validator/email_validator.dart';
import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/common/app_button.dart';
import 'package:eventvista/utils/app_dimensions.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../common/app_text_field.dart';
import '../base_view.dart';
import '../login/common/login_password_field.dart';

class SignUpView extends BaseView {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends BaseViewState<SignUpView> {
  var bloc = injection<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => bloc,
      child: BlocListener<AuthBloc, BaseState<AuthState>>(
        listener: (_, state) {
          if (state is AuthNeedsProfilePicture) {
            bloc.add(SignOutEvent());
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
                      children: [
                        SizedBox(height: 140.h),
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.kFontSize32,
                            color: AppColors.initColors().blackTextColor1,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Welcome to your Portal',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: AppDimensions.kFontSize14,
                            color: AppColors.initColors().greyTextColor1,
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              AppTextField(
                                label: 'Email',
                                hint: 'Enter your email',
                                controller: _emailController,
                                icon: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, right: 12.w),
                                  child: Image.asset(
                                    AppImages.icEmail,
                                    height: 20.h,
                                  ),
                                ),
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
                              SizedBox(height: 16.h),
                              PasswordField(
                                guideTitle: 'Password',
                                hint: 'Enter your password',
                                controller: _passwordController,
                                maxLines: 1,
                                icon: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, right: 12.w),
                                  child: Image.asset(
                                    AppImages.icLock,
                                    height: 20.h,
                                  ),
                                ),
                                textInputFormatter:
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                maxLength: 60,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required!";
                                  }
                                  if (checkPassword(value)) {
                                    return "Password is invalid!";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              PasswordField(
                                guideTitle: 'Confirm Password',
                                hint: 'Confirm your password',
                                controller: _confirmPasswordController,
                                maxLines: 1,
                                icon: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.w, right: 12.w),
                                  child: Image.asset(
                                    AppImages.icLock,
                                    height: 20.h,
                                  ),
                                ),
                                textInputFormatter:
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                maxLength: 60,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required!";
                                  }
                                  if (checkPassword(value)) {
                                    return "Password is invalid!";
                                  }
                                  if (_confirmPasswordController.text !=
                                      _passwordController.text) {
                                    return "Passwords do not match!";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  buttonText: 'Sign Up',
                  onTapButton: () {
                    if (formKey.currentState!.validate()) {
                      bloc.add(SignUpWithEmailEvent(
                        email: _emailController.text,
                        password: _confirmPasswordController.text,
                      ));
                    }
                  },
                  prefixIcon: Image.asset(
                    AppImages.icNext,
                    height: 20.h,
                  ),
                ),
                SizedBox(height: 16.h),
                AppButton(
                  buttonText: 'Login',
                  onTapButton: () {
                    Navigator.pop(context);
                  },
                  prefixIcon: Image.asset(
                    AppImages.icNext,
                    height: 20.h,
                  ),
                ),
                SizedBox(height: 75.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkPassword(String password) {
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{3,}$');
    return !regex.hasMatch(password);
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

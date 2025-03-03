import 'package:email_validator/email_validator.dart';
import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/common/app_button.dart';
import 'package:eventvista/utils/app_dimensions.dart';
import 'package:eventvista/utils/app_images.dart';
import 'package:eventvista/utils/navigation_routes.dart';
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
import 'common/login_password_field.dart';

class LoginView extends BaseView {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseViewState<LoginView> {
  var bloc = injection<AuthBloc>();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => bloc,
      child: BlocListener<AuthBloc, BaseState<AuthState>>(
        listener: (_, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.kDashboardView, (route) => false);
          } else if (state is AuthProfileIncomplete) {
            Navigator.pushNamed(context, Routes.kCompleteProfileView);
          } else if (state is AuthNeedsProfilePicture) {
            Navigator.pushNamed(context, Routes.kProfilePictureUploadView,
                arguments: _emailController.text);
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
                            ],
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    'Restore password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppDimensions.kFontSize14,
                                      color:
                                          AppColors.initColors().primaryOrange,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Image.asset(
                                    AppImages.icDiagonalArrow,
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  buttonText: 'Login',
                  onTapButton: () {
                    if (formKey.currentState!.validate()) {
                      bloc.add(SignInWithEmailEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
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
                  buttonText: 'Sign Up',
                  onTapButton: () {
                    Navigator.pushNamed(context, Routes.kSignUpView);
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

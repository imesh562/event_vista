import 'package:email_validator/email_validator.dart';
import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/utils/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_images.dart';
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
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.initColors().white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 180.h),
            Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppDimensions.kFontSize32,
                color: AppColors.initColors().blackTextColor1,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Welcome to your Portal',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppDimensions.kFontSize14,
                color: AppColors.initColors().greyTextColor1,
              ),
            ),
            SizedBox(height: 32.h),
            Form(
              key: _emailKey,
              child: AppTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                titleImage: AppImages.icEmail,
                isRequired: true,
                isPreLogin: true,
                maxLines: 1,
                maxLength: 100,
                inputType: TextInputType.emailAddress,
                textInputFormatter:
                    FilteringTextInputFormatter.deny(RegExp(r'[^\w.@+-]')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required!";
                  } else if (!EmailValidator.validate(value)) {
                    return "Email is invalid!";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.h),
            Form(
              key: _passwordKey,
              child: LoginPasswordField(
                guideTitle: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                isRequired: true,
                maxLines: 1,
                textInputFormatter:
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                isPreLogin: true,
                maxLength: 60,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required!";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

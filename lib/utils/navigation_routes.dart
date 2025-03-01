import 'package:eventvista/features/data/models/responses/posts_response.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../features/presentation/views/complete_profile/complete_profile_view.dart';
import '../features/presentation/views/dashboard/dashboard_view.dart';
import '../features/presentation/views/edit_profile/edit_view.dart';
import '../features/presentation/views/login/login_view.dart';
import '../features/presentation/views/posts/posts_view.dart';
import '../features/presentation/views/profile_picture/profile_picture_upload_view.dart';
import '../features/presentation/views/signup/signup_view.dart';
import '../features/presentation/views/splash/splash_view.dart';

class Routes {
  static const String kSplashView = "kSplashView";
  static const String kLoginView = "kLoginView";
  static const String kSignUpView = "kSignUpView";
  static const String kProfilePictureUploadView = "kProfilePictureUploadView";
  static const String kDashboardView = "kDashboardView";
  static const String kCompleteProfileView = "kCompleteProfileView";
  static const String kEditProfileView = "kEditProfileView";
  static const String kPostsView = "kPostsView";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.kSplashView:
        return PageTransition(
            child: SplashView(), type: PageTransitionType.fade);
      case Routes.kLoginView:
        return PageTransition(
            child: LoginView(), type: PageTransitionType.fade);
      case Routes.kSignUpView:
        return PageTransition(
            child: SignUpView(), type: PageTransitionType.fade);
      case Routes.kProfilePictureUploadView:
        return PageTransition(
            child: ProfilePictureUploadView(), type: PageTransitionType.fade);
      case Routes.kDashboardView:
        return PageTransition(
            child: DashboardView(), type: PageTransitionType.fade);
      case Routes.kCompleteProfileView:
        return PageTransition(
            child: CompleteProfileView(), type: PageTransitionType.fade);
      case Routes.kEditProfileView:
        return PageTransition(
            child: EditProfileView(), type: PageTransitionType.fade);
      case Routes.kPostsView:
        return PageTransition(
            child: PostsView(
              posts: settings.arguments as List<PostsResponse>,
            ),
            type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Invalid Route"),
            ),
          ),
        );
    }
  }
}

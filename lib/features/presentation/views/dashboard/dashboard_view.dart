import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/views/dashboard/profile/profile_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../base_view.dart';
import 'common/bottom_navbar.dart';
import 'home/home_view.dart';

class DashboardView extends BaseView {
  DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BaseViewState<DashboardView> {
  var bloc = injection<AuthBloc>();
  int selectedTab = 1;
  List<int> tabHistory = [1];

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedTab: selectedTab,
        callback: (value) {
          changeTab(value);
        },
      ),
      body: _getBody(),
    );
  }

  void changeTab(int value) {
    setState(() {
      if (selectedTab != value) {
        selectedTab = value;
        tabHistory.add(value);
      }
      if (selectedTab == 1) {}
    });
  }

  _getBody() {
    switch (selectedTab) {
      case 1:
        return HomeView();
      case 2:
        return ProfileView();
      default:
        return HomeView();
    }
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:eventvista/features/presentation/views/dashboard/home/home_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../base_view.dart';
import 'common/bottom_navbar.dart';

class DashboardView extends BaseView {
  final int tab;

  DashboardView({super.key, this.tab = 1});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BaseViewState<DashboardView> {
  var bloc = injection<AuthBloc>();
  int selectedTab = 1;
  int actionTab = 1;
  List<int> tabHistory = [1];

  @override
  void initState() {
    _setPageIndex();
    super.initState();
  }

  _setPageIndex() {
    setState(() {
      selectedTab = widget.tab;
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.initColors().white,
      bottomNavigationBar: BottomNavBar(
        selectedTab: selectedTab,
        callback: (value) {
          if (value == 4) {
            setState(() {
              actionTab = 1;
            });
          }
          changeTab(value);
        },
        appSharedData: appSharedData,
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
        return HomeView();
      case 3:
        return HomeView();
      case 4:
        return HomeView();
      case 5:
        return HomeView();
      default:
        return HomeView();
    }
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}

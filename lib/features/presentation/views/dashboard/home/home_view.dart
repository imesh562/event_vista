import 'package:eventvista/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/service/dependency_injection.dart';
import '../../../../../utils/app_colors.dart';
import '../../../bloc/base_bloc.dart';
import '../../../bloc/base_event.dart';
import '../../../bloc/base_state.dart';
import '../../base_view.dart';
import '../common/home_appbar.dart';

class HomeView extends BaseView {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseViewState<HomeView> {
  var bloc = injection<AuthBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => bloc,
      child: BlocListener<AuthBloc, BaseState<AuthState>>(
        listener: (_, state) {},
        child: Scaffold(
          backgroundColor: AppColors.initColors().white,
          appBar: HomeAppBar(),
          body: BlocProvider<AuthBloc>(
            create: (_) => bloc,
            child: BlocListener<AuthBloc, BaseState<AuthState>>(
                listener: (_, state) async {},
                child: Column(
                  children: [],
                )),
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

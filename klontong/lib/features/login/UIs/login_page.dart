import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klontong/features/login/UIs/login_content.dart';
import 'package:klontong/features/login/login_page.state.dart';
import 'package:klontong/features/login/login_page.uiapicubit.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static GoRoute get route => GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      );

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(title: const Text('Klontong'), centerTitle: true),
        body: BlocProvider<LoginPageUiCubit>(
          create: (ctx) => LoginPageUiCubit(userCubit: ctx.read<UserCubit>()),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: BlocBuilder<LoginPageUiCubit, LoginPageState>(
                buildWhen: (_, __) => false,
                builder: (_, state) => PageView(
                  controller: state.pageController,
                  children: const [
                    LoginContent(),
                    LoginContent(isForRegister: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

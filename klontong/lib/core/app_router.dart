import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klontong/core/global_keys.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.dart';
import 'package:klontong/features/catalog_items/create_edit_item/create_or_edit_item_page.dart';
import 'package:klontong/features/login/UIs/login_page.dart';

abstract class AppRouter {
  static GoRouter router = GoRouter(
    navigatorKey: coreGlobalKey,
    initialLocation: '/',
    errorPageBuilder: (_, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Route not found!: ${state.uri}')),
      ),
    ),
    redirect: (context, state) {
      final userState = context.read<UserCubit>().state;
      if (!userState.isLoggedIn) {
        return '/login';
      }
      return null;
    },
    routes: [
      LoginPage.route,
      CatalogPage.route(routes: [
        CreateOrEditItemPage.route,
      ]),
    ],
  );
}

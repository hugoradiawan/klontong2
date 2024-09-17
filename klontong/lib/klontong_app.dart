import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/app_router.dart';
import 'package:klontong/core/storages/secure_storage/secure_storage.cubit.dart';
import 'package:klontong/core/storages/secure_storage/secure_storage.state.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';
import 'package:klontong/core/user_manager/user.state.dart';
import 'package:toastification/toastification.dart';

class KlontongApp extends StatelessWidget {
  const KlontongApp({super.key});

  @override
  Widget build(_) => ToastificationWrapper(
        child: MultiBlocListener(
          listeners: [
            BlocListener<UserCubit, UserState>(
              listener: (ctx, event) {
                AppRouter.router.refresh();
                ctx
                    .read<SecureStorageBloc>()
                    .setAccessToken(event.accessTokens);
              },
            ),
            BlocListener<SecureStorageBloc, SecureStorageState>(
              listener: (ctx, event) {
                ctx.read<UserCubit>().updateAccestokens(event.accessTokens);
              },
            ),
          ],
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Klontong App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
          ),
        ),
      );
}

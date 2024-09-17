import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/http_client/http_client.bloc.dart';
import 'package:klontong/core/storages/hydrated_storage.dart';
import 'package:klontong/core/storages/secure_storage/secure_storage.cubit.dart';
import 'package:klontong/klontong_app.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KlontongStorage.init();
  runApp(
    MultiBlocProvider(
      providers: [
        SecureStorageBloc.provide,
        HttpClientBloc.provide,
        UserCubit.provide,
      ],
      child: const KlontongApp(),
    ),
  );
}

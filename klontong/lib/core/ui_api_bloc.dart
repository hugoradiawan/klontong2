import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:klontong/core/api_bloc.dart';
import 'package:klontong/core/typedef.dart';

abstract class UiCubit<T> extends HydratedCubit<T> {
  UiCubit(super.initialState);

  @override
  T? fromJson(JSON json) => null;

  @override
  JSON? toJson(T state) => null;
}

abstract class UiApiCubit<T, U extends ApiBloc> extends UiCubit<T> {
  final U api;
  UiApiCubit(super.initialState, this.api);
}

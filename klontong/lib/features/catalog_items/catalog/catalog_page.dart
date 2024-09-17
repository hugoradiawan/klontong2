import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:klontong/core/user_manager/user.cubit.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.state.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.uiapibloc.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/catalog/item_tile.dart';
import 'package:klontong/shared/UIs/category_chip.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static GoRoute route({required List<RouteBase> routes}) => GoRoute(
        path: '/',
        builder: (_, __) => const CatalogPage(),
        routes: routes,
      );

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Klontong'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: context.read<UserCubit>().logout,
            )
          ],
        ),
        body: Center(
          child: BlocProvider<CatalogPageUiApiBloc>(
            create: (_) => CatalogPageUiApiBloc(),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  width: math.max(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height),
                  child: BlocSelector<CatalogPageUiApiBloc, CatalogPageState,
                      List<Category>>(
                    selector: (state) => state.categories,
                    builder: (ctx, list) =>
                        ListView(scrollDirection: Axis.horizontal, children: [
                      const SizedBox(width: 8),
                      for (int i = 0; i < list.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CategoryChip(data: list[i], onSelected: () {}),
                        )
                    ]),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CatalogPageUiApiBloc, CatalogPageState>(
                    buildWhen: (previous, current) =>
                        previous.items != current.items ||
                        previous.refreshController != current.refreshController,
                    builder: (context, state) => state.refreshController != null
                        ? SmartRefresher(
                            controller: state.refreshController!,
                            onRefresh: context.read<CatalogPageUiApiBloc>().onRefresh,
                            onLoading: context.read<CatalogPageUiApiBloc>().onLoading,
                            enablePullUp: true,
                            child: MasonryGridView.count(
                              padding: const EdgeInsets.all(8),
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              itemCount: state.items.length,
                              itemBuilder: (context, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ItemTile(item: state.items[index]),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/item');
          },
          tooltip: 'Add Item',
          child: const Icon(Icons.add),
        ),
      );
}

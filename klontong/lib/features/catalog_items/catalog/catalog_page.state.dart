import 'package:equatable/equatable.dart';
import 'package:klontong/core/typedef.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/catalog/item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CatalogPageState extends Equatable {
  final List<Item> items;
  final List<Category> categories;
  final double getItemsProgress, getCategoriesProgress;
  final RefreshController? refreshController;
  final int page, limit;

  const CatalogPageState({
    this.items = const [],
    this.getItemsProgress = 0,
    this.getCategoriesProgress = 0,
    this.categories = const [],
    this.refreshController,
    this.page = 1,
    this.limit = 3,
  });

  CatalogPageState copyWith({
    double? getItemsProgress,
    double? getCategoriesProgress,
    List<Item>? items,
    List<Category>? categories,
    RefreshController? refreshController,
    int? page,
  }) =>
      CatalogPageState(
        items: items ?? this.items,
        categories: categories ?? this.categories,
        getItemsProgress: getItemsProgress ?? this.getItemsProgress,
        getCategoriesProgress:
            getCategoriesProgress ?? this.getCategoriesProgress,
        refreshController: refreshController ?? this.refreshController,
        page: page ?? this.page,
        limit: limit,
      );

  @override
  List<Object?> get props => [
        items,
        getItemsProgress,
        getCategoriesProgress,
        categories,
        refreshController,
        page,
      ];

  factory CatalogPageState.fromJson(JSON json) => CatalogPageState(
        categories: (json['categories'] as List?)
                ?.map((e) => Category.fromJson(e))
                .toList() ??
            [],
        items:
            (json['items'] as List?)?.map((e) => Item.fromJson(e)).toList() ??
                [],
      );

  JSON get toJson => {
        'categories': categories.map((e) => e.toJson()).toList(),
        'items': items.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => toJson.toString();
}

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';

class AddCategoryDialogState extends Equatable {
  final Category? category;
  final File? file;
  final double progress;
  const AddCategoryDialogState({this.category, this.file, this.progress = 0});
  @override
  List<Object?> get props => [category, file, progress];

  AddCategoryDialogState copyWith({
    Category? category,
    File? file,
    double? progress,
  }) =>
      AddCategoryDialogState(
        category: category ?? this.category,
        file: file ?? this.file,
        progress: progress ?? this.progress,
      );
}

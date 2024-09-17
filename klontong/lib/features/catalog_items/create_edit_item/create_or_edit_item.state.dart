import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:klontong/features/catalog_items/catalog/item.dart';

class CreateOrEditItemState extends Equatable {
  final Item? item;
  final File? file;
  final double progress;
  const CreateOrEditItemState({this.item, this.progress = 0, this.file});
  @override
  List<Object?> get props => [item, progress, file];

  CreateOrEditItemState copyWith({
    Item? item,
    File? file,
    double? progress,
  }) =>
      CreateOrEditItemState(
        item: item ?? this.item,
        file: file ?? this.file,
        progress: progress ?? this.progress,
      );
}
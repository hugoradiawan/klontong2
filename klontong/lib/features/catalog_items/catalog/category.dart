import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:klontong/core/typedef.dart';

class Category extends Equatable {
  final String? name, id, icon;
  final Color? color;

  const Category({
    this.name,
    this.id,
    this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [name, id, color, icon];

  factory Category.fromJson(JSON json) {
    late final Color? color;
    if (json['color'] is List?) {
      color = Color.fromARGB(
        255,
        (json['color'] as List?)?[0] ?? 255,
        (json['color'] as List?)?[1] ?? 255,
        (json['color'] as List?)?[2] ?? 255,
      );
    } else if (json['color'] is String?) {
      final List<int>? data = (json['color'] as String?)
          ?.split(',')
          .map((e) => int.tryParse(e) ?? 255)
          .toList();
      color = Color.fromARGB(
        255,
        data?[0] ?? 255,
        data?[1] ?? 255,
        data?[2] ?? 255,
      );
    }
    return Category(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      color: color,
      icon: json['icon'] as String?,
    );
  }

  JSON toJson({bool withImage = true, bool withId = true}) => {
        if (withId) '_id': id,
        'name': name,
        if (withImage) 'icon': icon,
        'color': [color?.red ?? 255, color?.green ?? 255, color?.blue ?? 255]
            .join(','),
      };

  Category copyWith({
    String? name,
    Color? color,
  }) =>
      Category(
        id: id,
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon,
      );
}

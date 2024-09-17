import 'package:equatable/equatable.dart';
import 'package:klontong/core/typedef.dart';

class Item extends Equatable {
  final double? weight, width, length, height, harga;
  final String? categoryName, name, description, image, sku, id, categoryId;

  bool get isValidToMake =>
      categoryId != null &&
      harga != null &&
      categoryName != null &&
      name != null &&
      description != null &&
      sku != null;

  const Item({
    this.id,
    this.categoryId,
    this.categoryName,
    this.name,
    this.description,
    this.harga,
    this.image,
    this.sku,
    this.weight,
    this.width,
    this.length,
    this.height,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        description,
        harga,
        sku,
        weight,
        width,
        length,
        height,
        categoryName,
        image,
      ];

  factory Item.fromJson(JSON json) => Item(
        id: json['_id'] as String?,
        categoryId: json['categoryId'] as String?,
        categoryName: json['categoryName'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        harga: double.tryParse((json['harga'] ?? '').toString()),
        sku: json['sku'] as String?,
        weight: double.tryParse((json['weight'] ?? '').toString()),
        width: double.tryParse((json['width'] ?? '').toString()),
        length: double.tryParse((json['length'] ?? '').toString()),
        height: double.tryParse((json['height'] ?? '').toString()),
        image: json['image'] as String?,
      );

  JSON toJson({bool withImage = true, bool withId = true}) => {
        if (withId) '_id': id,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'name': name,
        'description': description,
        'harga': harga,
        'sku': sku,
        'weight': weight,
        'width': width,
        'length': length,
        'height': height,
        if (withImage) 'image': image,
      };

  Item copyWith({
    String? categoryId,
    String? categoryName,
    String? name,
    String? description,
    double? harga,
    String? sku,
    double? weight,
    double? width,
    double? length,
    double? height,
  }) =>
      Item(
        id: id,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        name: name ?? this.name,
        description: description ?? this.description,
        harga: harga ?? this.harga,
        sku: sku ?? this.sku,
        weight: weight ?? this.weight,
        width: width ?? this.width,
        length: length ?? this.length,
        height: height ?? this.height,
        image: image,
      );
}

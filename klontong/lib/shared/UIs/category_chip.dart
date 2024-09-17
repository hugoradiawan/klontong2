import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/http_client/http_client.bloc.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.data,
    this.selected = false,
    this.onDelete,
    required this.onSelected,
  });

  final Category data;
  final bool selected;
  final VoidCallback onSelected;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: data.color ?? Theme.of(context).colorScheme.primary));
    return Theme(
      data: theme,
      child: InkWell(
        onTap: onSelected,
        child: Chip(
          backgroundColor: theme.colorScheme.inversePrimary,
          side: selected
              ? BorderSide(color: theme.colorScheme.primary, width: 4)
              : BorderSide.none,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.icon != null)
                ClipOval(
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.network(
                      context
                          .read<HttpClientBloc>()
                          .getCategoryIconUrl(data.icon!),
                      height: 16,
                      width: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                data.name ?? '',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          deleteIcon: onDelete != null
              ? Icon(
                  Icons.delete_outline_outlined,
                  color: theme.colorScheme.error,
                )
              : null,
          onDeleted: onDelete,
        ),
      ),
    );
  }
}

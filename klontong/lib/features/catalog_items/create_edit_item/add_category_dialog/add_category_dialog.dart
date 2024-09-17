import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.uiapibloc.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/create_edit_item/add_category_dialog/add_category_dialog.state.dart';
import 'package:klontong/features/catalog_items/create_edit_item/add_category_dialog/add_category_dialog.uiapibloc.dart';
import 'package:klontong/shared/UIs/shared.ui.dart';

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog({super.key, this.category});

  final Category? category;

  @override
  Widget build(context) => BlocProvider<AddCategoryDialogUiApiBloc>(
        create: (ctx) => AddCategoryDialogUiApiBloc(
          catalogPageUiApiBloc: ctx.read<CatalogPageUiApiBloc>(),
        ),
        child: BlocBuilder<AddCategoryDialogUiApiBloc, AddCategoryDialogState>(
          buildWhen: (_, __) => false,
          builder: (ctx, _) => SingleChildScrollView(
            child: Dialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    'Add Category',
                    style: TextStyle(
                      fontSize: 19,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: ctx.read<AddCategoryDialogUiApiBloc>().updateImage,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          height: 120,
                          child: BlocSelector<AddCategoryDialogUiApiBloc,
                              AddCategoryDialogState, File?>(
                            selector: (state) => state.file,
                            builder: (ctx1, file) => file == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(
                                          Icons.add,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        Text(
                                          'Add Image',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                      ])
                                : Image.file(file, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: category?.name,
                    onChanged:
                        ctx.read<AddCategoryDialogUiApiBloc>().updateName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    cursorColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    decoration: SharedUI.inputDecoration(
                      context: context,
                      hintText: 'Enter Category Name Here',
                      labelText: 'Category Name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose category color',
                    style: TextStyle(
                      fontSize: 19,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    children: Colors.primaries
                        .map(
                          (e) => BlocSelector<AddCategoryDialogUiApiBloc,
                              AddCategoryDialogState, Color?>(
                            selector: (state) => state.category?.color,
                            builder: (ctx2, color) => InkWell(
                              onTap: () => ctx2
                                  .read<AddCategoryDialogUiApiBloc>()
                                  .updateColor(e),
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: e,
                                    shape: BoxShape.circle,
                                  ),
                                  child: color == e
                                      ? Icon(Icons.check_circle_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)
                                      : null),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.7, 40),
                    ),
                    onPressed:
                        ctx.read<AddCategoryDialogUiApiBloc>().addCategory,
                    child: BlocSelector<AddCategoryDialogUiApiBloc,
                        AddCategoryDialogState, double>(
                      selector: (state) => state.progress,
                      builder: (context, progress) => Text(
                        progress > 0
                            ? 'Uploading... ${(progress * 100).round()}%'
                            : 'Create Category',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
}

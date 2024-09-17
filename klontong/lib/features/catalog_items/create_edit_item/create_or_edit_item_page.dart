import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.state.dart';
import 'package:klontong/features/catalog_items/catalog/catalog_page.uiapibloc.dart';
import 'package:klontong/features/catalog_items/catalog/category.dart';
import 'package:klontong/features/catalog_items/create_edit_item/add_category_dialog/add_category_dialog.dart';
import 'package:klontong/features/catalog_items/create_edit_item/create_or_edit_item.state.dart';
import 'package:klontong/features/catalog_items/create_edit_item/create_or_edit_item.uiapicubit.dart';
import 'package:klontong/shared/UIs/category_chip.dart';
import 'package:klontong/shared/UIs/shared.ui.dart';

class CreateOrEditItemPage extends StatelessWidget {
  const CreateOrEditItemPage({super.key, this.itemId});
  final String? itemId;

  static GoRoute get route => GoRoute(
          path: 'item',
          builder: (context, _) {
            try {
              return BlocProvider<CatalogPageUiApiBloc>.value(
                value: context.read<CatalogPageUiApiBloc>(),
                child: const CreateOrEditItemPage(),
              );
            } catch (_) {
              return BlocProvider(
                create: (_) => CatalogPageUiApiBloc(),
                child: const CreateOrEditItemPage(),
              );
            }
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                try {
                  return BlocProvider<CatalogPageUiApiBloc>.value(
                    value: context.read<CatalogPageUiApiBloc>(),
                    child: CreateOrEditItemPage(
                      itemId: state.pathParameters['id'],
                    ),
                  );
                } catch (_) {
                  return BlocProvider(
                    create: (_) => CatalogPageUiApiBloc(),
                    child: CreateOrEditItemPage(
                      itemId: state.pathParameters['id'],
                    ),
                  );
                }
              },
            ),
          ]);

  @override
  Widget build(context) => BlocProvider<CreateOrEditItemUiApiCubit>(
        create: (ctx) => CreateOrEditItemUiApiCubit(
          itemId: itemId,
          catalogPageUiApiBloc: ctx.read<CatalogPageUiApiBloc>(),
        ),
        child: BlocBuilder<CreateOrEditItemUiApiCubit, CreateOrEditItemState>(
            buildWhen: (_, __) => false,
            builder: (ctx, state) => Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: const Text('Create Item'),
                    actions: [
                      if (itemId != null)
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                    ],
                  ),
                  body: ListView(padding: const EdgeInsets.all(8), children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: Row(children: [
                        Flexible(
                          flex: 2,
                          child: InkWell(
                            onTap: ctx
                                .read<CreateOrEditItemUiApiCubit>()
                                .updateImage,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  height: 120,
                                  child: BlocBuilder<CreateOrEditItemUiApiCubit,
                                      CreateOrEditItemState>(
                                    buildWhen: (previous, current) =>
                                        previous.file != current.file ||
                                        previous.item?.image !=
                                            current.item?.image,
                                    builder: (context, state) =>
                                        state.file == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                            : Image.file(
                                                state.file!,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Column(children: [
                            Expanded(
                              child: BlocSelector<CreateOrEditItemUiApiCubit,
                                  CreateOrEditItemState, String?>(
                                selector: (state) => state.item?.name,
                                builder: (_, name) => TextFormField(
                                  initialValue: name,
                                  onChanged: ctx
                                      .read<CreateOrEditItemUiApiCubit>()
                                      .updateName,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  cursorColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  decoration: SharedUI.inputDecoration(
                                    context: context,
                                    hintText: 'Enter Item Name Here',
                                    labelText: 'Item Name',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: BlocSelector<CreateOrEditItemUiApiCubit,
                                  CreateOrEditItemState, String?>(
                                selector: (state) => state.item?.sku,
                                builder: (_, sku) => TextFormField(
                                    initialValue: sku,
                                    onChanged: ctx
                                        .read<CreateOrEditItemUiApiCubit>()
                                        .updateSku,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                    cursorColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    decoration: SharedUI.inputDecoration(
                                      context: context,
                                      hintText: 'Enter The Item SKU Here',
                                      labelText: 'Item SKU',
                                    )),
                              ),
                            ),
                          ]),
                        )
                      ]),
                    ),
                    const SizedBox(height: 16),
                    BlocSelector<CreateOrEditItemUiApiCubit,
                        CreateOrEditItemState, String?>(
                      selector: (state) => state.item?.description,
                      builder: (_, desciption) => TextFormField(
                          initialValue: desciption,
                          onChanged: ctx
                              .read<CreateOrEditItemUiApiCubit>()
                              .updateDescription,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          maxLines: 8,
                          cursorColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          decoration: SharedUI.inputDecoration(
                            context: context,
                            hintText: 'Enter The Item Description Here',
                            labelText: 'Item Description',
                          )),
                    ),
                    const SizedBox(height: 16),
                    BlocSelector<CreateOrEditItemUiApiCubit,
                        CreateOrEditItemState, double?>(
                      selector: (state) => state.item?.harga,
                      builder: (_, harga) => TextFormField(
                          initialValue: harga?.toString(),
                          onChanged: ctx
                              .read<CreateOrEditItemUiApiCubit>()
                              .updatePrice,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          keyboardType: TextInputType.number,
                          cursorColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          decoration: SharedUI.inputDecoration(
                            context: context,
                            hintText: 'Enter The Item Price Here',
                            labelText: 'Item Price',
                          )),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Item Dimension & Weight',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: BlocSelector<CreateOrEditItemUiApiCubit,
                              CreateOrEditItemState, double?>(
                            selector: (state) => state.item?.weight,
                            builder: (_, weight) => TextFormField(
                                initialValue: weight?.toString(),
                                onChanged: ctx
                                    .read<CreateOrEditItemUiApiCubit>()
                                    .updateWeight,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                keyboardType: TextInputType.number,
                                cursorColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                decoration: SharedUI.inputDecoration(
                                  context: context,
                                  hintText: 'Enter The Item Weight',
                                  labelText: 'Item Weight',
                                )),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BlocSelector<CreateOrEditItemUiApiCubit,
                              CreateOrEditItemState, double?>(
                            selector: (state) => state.item?.height,
                            builder: (_, height) => TextFormField(
                                initialValue: height?.toString(),
                                onChanged: ctx
                                    .read<CreateOrEditItemUiApiCubit>()
                                    .updateHeight,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                keyboardType: TextInputType.number,
                                cursorColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                decoration: SharedUI.inputDecoration(
                                  context: context,
                                  hintText: 'Enter The Item Height',
                                  labelText: 'Item Height',
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: BlocSelector<CreateOrEditItemUiApiCubit,
                            CreateOrEditItemState, double?>(
                          selector: (state) => state.item?.width,
                          builder: (_, width) => TextFormField(
                              initialValue: width?.toString(),
                              onChanged: ctx
                                  .read<CreateOrEditItemUiApiCubit>()
                                  .updateWidth,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              keyboardType: TextInputType.number,
                              cursorColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              decoration: SharedUI.inputDecoration(
                                context: context,
                                hintText: 'Enter The Item Width',
                                labelText: 'Item Width',
                              )),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BlocSelector<CreateOrEditItemUiApiCubit,
                            CreateOrEditItemState, double?>(
                          selector: (state) => state.item?.length,
                          builder: (_, length) => TextFormField(
                              initialValue: length?.toString(),
                              onChanged: ctx
                                  .read<CreateOrEditItemUiApiCubit>()
                                  .updateLength,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              keyboardType: TextInputType.number,
                              cursorColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              decoration: SharedUI.inputDecoration(
                                context: context,
                                hintText: 'Enter The Item Length',
                                labelText: 'Item Length',
                              )),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    Text(
                      'Item Category',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocSelector<CatalogPageUiApiBloc, CatalogPageState,
                        List<Category>>(
                      selector: (state) => state.categories,
                      builder: (context, list) => Wrap(spacing: 8, children: [
                        for (int i = 0; i < list.length; i++)
                          BlocSelector<CreateOrEditItemUiApiCubit,
                              CreateOrEditItemState, String?>(
                            selector: (state) => state.item?.categoryId,
                            builder: (ctx4, cId) => CategoryChip(
                              data: list[i],
                              onSelected: () {
                                ctx4
                                    .read<CreateOrEditItemUiApiCubit>()
                                    .updateCategory(list[i]);
                              },
                              selected: list[i].id == cId,
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctxDialog) =>
                                  BlocProvider<CatalogPageUiApiBloc>.value(
                                value: ctx.read<CatalogPageUiApiBloc>(),
                                child: const AddCategoryDialog(),
                              ),
                            );
                          },
                          child: Chip(
                            side: BorderSide.none,
                            label:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'New Catagory',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ]),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      onPressed:
                          ctx.read<CreateOrEditItemUiApiCubit>().onCreateItem,
                      child: BlocSelector<CreateOrEditItemUiApiCubit,
                          CreateOrEditItemState, double>(
                        selector: (state) => state.progress,
                        builder: (context, progress) => Text(
                          progress > 0
                              ? 'Uploading... ${(progress * 100).round()}%'
                              : 'Create Item',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ]),
                )),
      );
}

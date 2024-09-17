import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/http_client/http_client.bloc.dart';
import 'package:klontong/features/catalog_items/catalog/item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.item});

  final Item item;

  @override
  Widget build(context) => Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.image != null)
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.inversePrimary,
                margin: const EdgeInsets.only(bottom: 4),
                child: Image.network(
                    context.read<HttpClientBloc>().getItemImageUrl(item.image!),
                    fit: BoxFit.fitWidth),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(
                item.name ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(item.description ?? ''),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Price ${item.harga}'),
            ),
          ],
        ),
      );
}

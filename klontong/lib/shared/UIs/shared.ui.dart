import 'package:flutter/material.dart';

class SharedUI {
  static InputDecoration inputDecoration({
    required BuildContext context,
    required String hintText,
    required String labelText,
  }) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintText: hintText,
      label: Container(
        padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(labelText),
      ),
      alignLabelWithHint: true,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

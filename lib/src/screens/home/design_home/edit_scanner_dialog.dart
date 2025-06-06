import 'package:flutter/material.dart';
import 'package:untitled/src/models/spider_scanner.dart';
import 'package:untitled/src/screens/home/cubit/home_cubit.dart';

void showEditScannerDialog(
    BuildContext context, SpiderScanner scanner, HomeCubit cubit) {
  final nameCtrl = TextEditingController(text: scanner.name);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Edit Scanner"),
      content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: "New Name")),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            cubit.updateScanner(
                SpiderScanner(id: scanner.id, name: nameCtrl.text));
          },
          child: const Text("Save"),
        )
      ],
    ),
  );
}

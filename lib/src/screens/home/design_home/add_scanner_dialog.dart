import 'package:flutter/material.dart';
import 'package:untitled/src/screens/home/cubit/home_cubit.dart';

void showAddScannerDialog(BuildContext context, HomeCubit cubit) {
  final nameCtrl = TextEditingController();
  final idCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Add Spider Scanner"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name")),
          TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: "ID")),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            if (nameCtrl.text.isEmpty || idCtrl.text.isEmpty) return;
            Navigator.pop(context);
            cubit.addScanner(nameCtrl.text, idCtrl.text);
          },
          child: const Text("Add"),
        )
      ],
    ),
  );
}

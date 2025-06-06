import 'package:flutter/material.dart';
import 'package:untitled/src/models/spider_scanner.dart';

class ScannerList extends StatelessWidget {
  final List<SpiderScanner> scanners;
  final void Function(SpiderScanner) onEdit;
  final void Function(String) onDelete;

  const ScannerList(
      {super.key,
      required this.scanners,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (scanners.isEmpty) {
      return const Center(
          child: Text("No scanners added.",
              style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      itemCount: scanners.length,
      itemBuilder: (_, index) {
        final s = scanners[index];
        return Card(
          color: const Color(0xFF1E1E1E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(s.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text("ID: ${s.id}",
                style: const TextStyle(color: Colors.white54)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.bug_report, color: Colors.greenAccent),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Scanning with ${s.name}...")));
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () => onEdit(s)),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => onDelete(s.id)),
              ],
            ),
          ),
        );
      },
    );
  }
}

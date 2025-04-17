import 'package:flutter/material.dart';

import '../../data/spider_scanner_storage.dart';
import '../../models/spider_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpiderScannerStorage storage = SpiderScannerStorage();
  List<SpiderScanner> scanners = [];

  @override
  void initState() {
    super.initState();
    _loadScanners();
  }

  Future<void> _loadScanners() async {
    final list = await storage.getAll();
    setState(() => scanners = list);
  }

  Future<void> _addScannerDialog() async {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Spider Scanner"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: "ID"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || idCtrl.text.isEmpty) return;
              await storage.add(SpiderScanner(id: idCtrl.text, name: nameCtrl.text));
              await _loadScanners();
              if(context.mounted) {
                Navigator.pop(ctx);
              }
              },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  Future<void> _editScannerDialog(SpiderScanner scanner) async {
    final nameCtrl = TextEditingController(text: scanner.name);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Scanner"),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: "New Name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final updated = SpiderScanner(id: scanner.id, name: nameCtrl.text);
              await storage.update(updated);
              await _loadScanners();
              if(context.mounted) {
                Navigator.pop(ctx);
              }
              },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Future<void> _deleteScanner(String id) async {
    await storage.delete(id);
    await _loadScanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Spider Scanners", style: TextStyle(color: Colors.greenAccent)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.greenAccent),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: _addScannerDialog,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (scanners.isEmpty)
              const Center(
                child: Text("No scanners added.",
                    style: TextStyle(color: Colors.white54)),
              ),
            ...scanners.map((s) => Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(s.name, style: const TextStyle(color: Colors.white)),
                subtitle: Text("ID: ${s.id}", style: const TextStyle(color: Colors.white54)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.bug_report, color: Colors.greenAccent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Scanning with ${s.name}..."),
                        ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white70),
                      onPressed: () => _editScannerDialog(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteScanner(s.id),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

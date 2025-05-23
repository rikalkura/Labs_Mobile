import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/spider_scanner_storage.dart';
import '../../models/spider_scanner.dart';
import '../../services/connectivity_service.dart';
import '../../services/mqtt_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpiderScannerStorage storage = SpiderScannerStorage();
  final ConnectivityService connectivity = ConnectivityService();

  late final MQTTClientWrapper mqtt;

  List<SpiderScanner> scanners = [];
  String lastMessage = '';
  late final StreamSubscription<ConnectivityResult> _connectionSub;

  @override
  void initState() {
    super.initState();
    _loadScanners();
    _initMqtt();
    _monitorInternet();
  }

  void _monitorInternet() {
    _connectionSub = connectivity.onStatusChanged.listen((status) {
      if (!mounted) return;
      if (status == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Internet connection lost"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Internet connection restored"),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  Future<void> _initMqtt() async {
    mqtt = MQTTClientWrapper(
      host: '33735205e79649f9aed60121f9c072ce.s1.eu.hivemq.cloud',
      port: 8883,
      clientIdentifier: 'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      username: 'admin',
      password: 'Qwerty123',
      onData: ({int? sensor}) {
        if (!mounted) return;
        setState(() {
          lastMessage = 'Sensor value: ${sensor ?? 'N/A'}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('MQTT [service/sensor]: ${sensor ?? 'No data'}')),
        );
      },
    );

    await mqtt.prepareMqttClient();
  }

  Future<void> _loadScanners() async {
    final list = await storage.getAll();
    if (!mounted) return;
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
              Navigator.pop(ctx);
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
              Navigator.pop(ctx);
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
  void dispose() {
    mqtt.disconnect();
    _connectionSub.cancel();
    super.dispose();
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
            if (lastMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.message, color: Colors.greenAccent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lastMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            if (scanners.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No scanners added.",
                      style: TextStyle(color: Colors.white54)),
                ),
              ),
            if (scanners.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: scanners.length,
                  itemBuilder: (ctx, index) {
                    final s = scanners[index];
                    return Card(
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
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

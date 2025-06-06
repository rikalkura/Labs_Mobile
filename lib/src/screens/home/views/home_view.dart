import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/models/spider_scanner.dart';
import 'package:untitled/src/screens/home/cubit/home_cubit.dart';
import 'package:untitled/src/screens/home/cubit/home_state.dart';
import 'package:untitled/src/screens/home/design_home/add_scanner_dialog.dart';
import 'package:untitled/src/screens/home/design_home/edit_scanner_dialog.dart';
import 'package:untitled/src/screens/home/design_home/last_message_banner.dart';
import 'package:untitled/src/screens/home/design_home/scanner_list.dart';
import 'package:untitled/src/screens/scanner/qrcode_scan_page.dart';
import 'package:untitled/src/screens/scanner/saved_message_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeConnectionLost) {
          _showSnack(context, "Internet connection lost", Colors.redAccent);
        } else if (state is HomeConnectionRestored) {
          _showSnack(context, "Internet connection restored", Colors.green);
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        final scanners = state is HomeLoaded ? state.scanners : [];
        final lastMessage = state is HomeLoaded ? state.lastMessage : '';

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: const Text("Spider Scanners",
                style: TextStyle(color: Colors.greenAccent)),
            actions: [
              IconButton(
                icon: const Icon(Icons.person, color: Colors.greenAccent),
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.greenAccent,
            onPressed: () => showAddScannerDialog(context, cubit),
            child: const Icon(Icons.add, color: Colors.black),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (lastMessage.isNotEmpty)
                  LastMessageBanner(message: lastMessage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QRScannerScreen())),
                      icon: const Icon(Icons.qr_code),
                      label: const Text("Scan QR"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MessageScreen())),
                      icon: const Icon(Icons.save_alt),
                      label: const Text("Saved Msg"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ScannerList(
                      scanners: List<SpiderScanner>.from(scanners),
                      onEdit: (s) => showEditScannerDialog(context, s, cubit),
                      onDelete: cubit.deleteScanner),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnack(BuildContext context, String msg, Color bg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'cubit/scanner_cubit.dart';
import 'cubit/scanner_state.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScannerCubit(),
      child: const _ScannerView(),
    );
  }
}

class _ScannerView extends StatefulWidget {
  const _ScannerView();

  @override
  State<_ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<_ScannerView> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR-code')),
      body: BlocConsumer<ScannerCubit, ScannerState>(
        listener: (context, state) {
          if (state is ScannerReceived) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ESP32: ${state.response}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ScannerConnecting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScannerConnectionFailed) {
            return const Center(child: Text('ESP32 not connected via USB'));
          }

          return Column(
            children: [
              Expanded(
                flex: 4,
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcode = capture.barcodes.firstOrNull?.rawValue;
                    if (barcode != null && !scanned) {
                      context.read<ScannerCubit>().send(barcode);
                      setState(() => scanned = true);
                    }
                  },
                ),
              ),
              if (state is ScannerSending)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              else if (state is ScannerSent)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('QR-code scanned and sent!'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ScannerCubit>().reset();
                          setState(() => scanned = false);
                        },
                        child: const Text('Scan more'),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usb_serial/usb_serial.dart';

import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  UsbPort? _port;

  ScannerCubit() : super(ScannerInitial()) {
    _initializeUSB();
  }

  Future<void> _initializeUSB() async {
    emit(ScannerConnecting());
    final devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      _port = await devices[0].create();
      final opened = await _port?.open() ?? false;
      if (!opened) {
        emit(ScannerConnectionFailed());
        return;
      }

      await _port?.setDTR(true);
      await _port?.setRTS(true);
      await _port?.setPortParameters(
          9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

      _port?.inputStream?.listen((Uint8List data) {
        final response = String.fromCharCodes(data).trim();
        if (response.isNotEmpty) {
          emit(ScannerReceived(response));
        }
      });

      await _port?.write(Uint8List.fromList('GET\n'.codeUnits));
      emit(ScannerReady());
    } else {
      emit(ScannerConnectionFailed());
    }
  }

  Future<void> send(String data) async {
    if (_port == null) return;
    emit(ScannerSending());
    await _port?.write(Uint8List.fromList('$data\n'.codeUnits));
    emit(ScannerSent(data));
  }

  Future<void> reset() async {
    emit(ScannerReady());
  }

  @override
  Future<void> close() async {
    await _port?.close();
    return super.close();
  }
}

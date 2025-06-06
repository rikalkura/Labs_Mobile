import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  UsbPort? _port;
  Transaction<String>? _transaction;

  MessageCubit() : super(MessageInitial());

  Future<void> readFromUSB() async {
    emit(MessageLoading());

    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      emit(MessageError('No USB devices found'));
      return;
    }

    _port = await devices[0].create();
    final opened = await _port!.open();
    if (!opened) {
      emit(MessageError('Failed to open port'));
      return;
    }

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    await _port!.write(Uint8List.fromList('GET\n'.codeUnits));

    _transaction = Transaction.stringTerminated(
      _port!.inputStream!,
      Uint8List.fromList([13, 10]), // \r\n
    );

    _transaction!.stream.listen((data) {
      emit(MessageReceived(data.trim()));
      _transaction?.dispose();
    });
  }

  @override
  Future<void> close() async {
    _transaction?.dispose();
    await _port?.close();
    return super.close();
  }
}

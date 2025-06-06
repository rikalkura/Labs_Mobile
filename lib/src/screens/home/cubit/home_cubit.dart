import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/data/spider_scanner_storage.dart';
import 'package:untitled/src/models/spider_scanner.dart';
import 'package:untitled/src/services/connectivity_service.dart';
import 'package:untitled/src/services/mqtt_service.dart';
import 'package:untitled/src/services/usb_service.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SpiderScannerStorage storage;
  final ConnectivityService connectivity;
  final UsbSerialService usb;
  late final MQTTClientWrapper mqtt;
  late final StreamSubscription<ConnectivityResult> _connSub;

  HomeCubit({
    required this.storage,
    required this.connectivity,
    required this.usb,
  }) : super(HomeInitial()) {
    _init();
  }

  Future<void> _init() async {
    _monitorConnection();
    await loadScanners();
    await _setupMqtt();
  }

  Future<void> _setupMqtt() async {
    mqtt = MQTTClientWrapper(
      host: '33735205e79649f9aed60121f9c072ce.s1.eu.hivemq.cloud',
      port: 8883,
      clientIdentifier:
          'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      username: 'admin',
      password: 'Qwerty123',
      onData: ({int? sensor}) {
        emit((state as HomeLoaded).copyWith(
          lastMessage: 'Sensor value: ${sensor ?? 'N/A'}',
        ));
      },
    );
    await mqtt.prepareMqttClient();
  }

  Future<void> loadScanners() async {
    final list = await storage.getAll();
    emit(HomeLoaded(scanners: list, lastMessage: ''));
  }

  Future<void> addScanner(String name, String id) async {
    await storage.add(SpiderScanner(id: id, name: name));
    await loadScanners();
  }

  Future<void> updateScanner(SpiderScanner updated) async {
    await storage.update(updated);
    await loadScanners();
  }

  Future<void> deleteScanner(String id) async {
    await storage.delete(id);
    await loadScanners();
  }

  void _monitorConnection() {
    _connSub = connectivity.onStatusChanged.listen((status) {
      if (status == ConnectivityResult.none) {
        emit(HomeConnectionLost());
      } else {
        emit(HomeConnectionRestored());
      }
    });
  }

  void resetStatusToNormal() {
    if (state is HomeConnectionLost || state is HomeConnectionRestored) {
      emit((state as dynamic).copyWithStatusOnly());
    }
  }

  void disconnect() {
    mqtt.disconnect();
    _connSub.cancel();
  }

  @override
  Future<void> close() {
    disconnect();
    return super.close();
  }
}

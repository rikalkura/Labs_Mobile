import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/src/data/spider_scanner_storage.dart';
import 'package:untitled/src/services/connectivity_service.dart';
import 'package:untitled/src/services/usb_service.dart';

import 'cubit/home_cubit.dart';
import 'views/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        storage: SpiderScannerStorage(),
        connectivity: ConnectivityService(),
        usb: UsbSerialService(),
      ),
      child: const HomeView(),
    );
  }
}

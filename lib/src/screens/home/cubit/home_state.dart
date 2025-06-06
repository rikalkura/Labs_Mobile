import 'package:untitled/src/models/spider_scanner.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SpiderScanner> scanners;
  final String lastMessage;

  HomeLoaded({required this.scanners, required this.lastMessage});

  HomeLoaded copyWith({
    List<SpiderScanner>? scanners,
    String? lastMessage,
  }) {
    return HomeLoaded(
      scanners: scanners ?? this.scanners,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  HomeLoaded copyWithStatusOnly() => this;
}

class HomeConnectionLost extends HomeLoaded {
  HomeConnectionLost() : super(scanners: const [], lastMessage: '');
}

class HomeConnectionRestored extends HomeLoaded {
  HomeConnectionRestored() : super(scanners: const [], lastMessage: '');
}

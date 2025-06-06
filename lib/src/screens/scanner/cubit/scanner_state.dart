abstract class ScannerState {}

class ScannerInitial extends ScannerState {}

class ScannerConnecting extends ScannerState {}

class ScannerConnectionFailed extends ScannerState {}

class ScannerReady extends ScannerState {}

class ScannerSending extends ScannerState {}

class ScannerSent extends ScannerState {
  final String data;

  ScannerSent(this.data);
}

class ScannerReceived extends ScannerState {
  final String response;

  ScannerReceived(this.response);
}

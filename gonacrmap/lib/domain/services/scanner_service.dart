import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerService {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // Evita lecturas repetidas
  );

  MobileScannerController get scannerController => _scannerController;

  void startScan(Function(String) onCodeScanned) {
    _scannerController.start();
    _scannerController.barcodes.listen((barcode) {
      final String? rawValue = barcode.barcodes.first.rawValue;
      if (rawValue != null) {
        onCodeScanned(rawValue);
        _scannerController.stop(); // Detiene el escaneo después de leer un código
      }
    });
  }

  void stopScan() {
    _scannerController.stop();
  }

  void dispose() {
    _scannerController.dispose();
  }
}

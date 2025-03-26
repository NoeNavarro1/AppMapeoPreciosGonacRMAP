import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  final Function(String) onCodeScanned;

  const Scanner({super.key, required this.onCodeScanned});

  @override
  State<Scanner> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<Scanner> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    torchEnabled: false,
  );

  @override
  void dispose() {
    _scannerController.dispose(); // Liberar la cámara al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escanear Código de Barras')),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: (barcode) {
                if (barcode.barcodes.isNotEmpty) {
                  final rawValue = barcode.barcodes.first.rawValue;
                  if (rawValue != null) {
                    widget.onCodeScanned(rawValue);
                    Navigator.pop(context); // Cierra la pantalla del escáner
                  }
                }
            },
              scanWindow: Rect.fromLTWH(30, 300, 30, 30)
            ),
          ],
        ),
      ),
    );
  }
}

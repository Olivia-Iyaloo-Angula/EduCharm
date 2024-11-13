import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (qrText != null)
                  ? GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(qrText!);
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text(
                        'Result: $qrText',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      qrText = scanData.code?.trim();

      if (qrText != null) {
        final Uri url = Uri.parse(qrText!);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }

      controller.resumeCamera();
      setState(() {}); // Refresh UI to show scanned result
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

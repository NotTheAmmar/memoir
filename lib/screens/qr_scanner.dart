import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memoir/extensions.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// To Scan Public Key from QR Code
///
/// Pops the page when the scanned data
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  /// QRView Key
  final GlobalKey _key = GlobalKey();

  /// Controller for QRView
  QRViewController? _controller;

  /// Whether the Flash is ON or OFF
  bool _flashOn = false;

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  /// Sets the QRViewController when QRView is created
  ///
  /// Listens for the first data scanned then pops the page with the value
  void _onQRViewCreated(QRViewController controller) {
    setState(() => _controller = controller);

    _controller?.scannedDataStream.first.then((data) {
      context.navigator.pop(data.code);
    });
  }

  /// Turns on the flash if it is off
  void _turnOnFlash() {
    if (!_flashOn) {
      _controller?.toggleFlash().then((_) {
        setState(() => _flashOn = true);
      });
    }
  }

  /// Turns off the flash if it is on
  void _turnOffFlash() {
    if (_flashOn) {
      _controller?.toggleFlash().then((_) {
        setState(() => _flashOn = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: _key,
            onQRViewCreated: _onQRViewCreated,
            formatsAllowed: const [BarcodeFormat.qrcode],
            overlay: QrScannerOverlayShape(
              borderColor: context.colorScheme.primary,
              borderLength: 40,
              borderRadius: 20,
              borderWidth: 5,
              cutOutSize: 300,
              overlayColor: context.colorScheme.surface.withOpacity(0.75),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    tooltip: "Cancel",
                    onPressed: context.navigator.pop,
                    icon: const FaIcon(FontAwesomeIcons.xmark),
                  ),
                  GestureDetector(
                    onTapDown: (_) => _turnOnFlash(),
                    onTapUp: (_) => _turnOffFlash(),
                    child: FaIcon(
                      FontAwesomeIcons.boltLightning,
                      color: _flashOn ? Colors.blue : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPageView extends StatefulWidget {
  const BarcodeScannerPageView({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageViewState createState() => _BarcodeScannerPageViewState();
}

class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcodeCapture;
  bool isScanning = true;
  String scannedText = "";
  late AnimationController _lineController;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _lineController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: [
          cameraView(),
          Container(),
        ],
      ),
    );
  }

  Widget cameraView() {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              startDelay: true,
              controller: MobileScannerController(torchEnabled: false),
              fit: BoxFit.contain,
              onDetect: (capture) => setBarcodeCapture(capture),
            ),
            AnimatedBuilder(
              animation: _lineController,
              builder: (context, child) {
                final boxSize = 200.0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: (MediaQuery.of(context).size.width - boxSize) / 2,
                      top: 200.0,
                      width: boxSize,
                      height: boxSize,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors
                                .grey, // Ganti warna sesuai keinginan Anda
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 100,
                      right: 100,
                      top: 150.0 +
                          (boxSize / 2 - 1) +
                          (boxSize / 2) * _lineController.value,
                      height: 2.0,
                      child: Container(
                        color:
                            Colors.green, // Ganti warna sesuai keinginan Anda
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  void setBarcodeCapture(BarcodeCapture capture) {
    setState(() {
      barcodeCapture = capture;
      if (barcodeCapture != null) {
        scannedText = barcodeCapture!.barcodes.first.rawValue ?? "";
        processScannedText();
      } else {
        scannedText = "";
        // Tambahkan kembali perintah pemindaian setelah hasil tidak valid
        isScanning = true;
      }
    });
  }

  void processScannedText() {
    if (isLink(scannedText)) {
      // Ini adalah URL, tampilkan pesan sukses dan linknya
      showSuccessMessage(scannedText);
    } else {
      // Bukan URL, tampilkan pesan invalid
      showInvalidQRCodeMessage();
    }
  }

  bool isLink(String text) {
    return text.startsWith("http://Kelompok1PBP") ||
        text.startsWith("https://Kelompok1PBP");
  }

  void showSuccessMessage(String link) {
    // Navigasi kembali ke halaman sebelumnya dan tampilkan pesan sukses
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sukses"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("QR Code sukses discan."),
              SizedBox(height: 10),
              Text("Link: $link"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void showInvalidQRCodeMessage() {
    // Tampilkan pesan invalid QR code
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("QR Code Invalid"),
          content: Text("QR Code yang discan tidak valid."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }
}

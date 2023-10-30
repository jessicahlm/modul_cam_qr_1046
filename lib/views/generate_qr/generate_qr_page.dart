import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatelessWidget {
  const GenerateQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('QR Generate'),
      ), // AppBar

      body: Center(
        child: QrImageView(
          data: 'https://pub.dev/packages/qr_flutter', //Masukan Link tertentu
          version: 6,
          padding: const EdgeInsets.all(50),
          //background color foreground color
        ),
      ),
    );
  }
}

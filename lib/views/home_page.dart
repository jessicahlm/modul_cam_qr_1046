import 'package:flutter/material.dart';
import 'package:modul_cam_qr_1046/constant/app_constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  navigateTo(BuildContext context, String routeName) =>
      Navigator.pushNamed(context, routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LabelTextConstant.homePageAppBarTitle),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () =>
                  navigateTo(context, RouteConstant.routeToQrGeneratePage),
              child: const Text(ButtonTextConstant.qrGenerate),
            ),
            ElevatedButton(
              onPressed: () => navigateTo(context, RouteConstant.routeToQrCam),
              child: const Text(ButtonTextConstant.camera),
            ),
            ElevatedButton(
                onPressed: () =>
                    navigateTo(context, RouteConstant.routeToQrScanPage),
                child: const Text(ButtonTextConstant.qrScanning)),
          ],
        ),
      ),
    );
  }
}

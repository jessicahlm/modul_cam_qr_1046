import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:modul_cam_qr_1046/utils/logging_utils.dart';
import 'package:modul_cam_qr_1046/views/camera/display_picture.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;
  var count = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    LoggingUtils.logStartFunction("initialize camera".toUpperCase());
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeCameraFuture = _cameraController.initialize();
    if (mounted) {
      LoggingUtils.logEndFunction("success initialize camera".toUpperCase());
      setState(() {});
    }
  }

  @override
  void dispose() {
    LoggingUtils.logStartFunction("dispose CameraView".toUpperCase());
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeCameraFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ), // FutureBuilder
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await previewImageResult(),
        child: const Icon(Icons.camera_alt),
      ), // FloatingActionButton
    ); // Scaffold
  }

  Future<DisplayPictureScreen?> previewImageResult() async {
    String activity = "PREVIEW IMAGE RESULT";
    LoggingUtils.logStartFunction(activity);
    try {
      await _initializeCameraFuture;
      final image = await _cameraController.takePicture();
      if (!mounted) return null;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            _cameraController.pausePreview();
            LoggingUtils.logDebugValue(
                "get image on previewImageResult".toUpperCase(),
                "image.path: ${image.path}");
            return DisplayPictureScreen(
                imagePath: image.path, cameraController: _cameraController);
          },
        ), // MaterialPageRoute
      );
    } catch (e) {
      LoggingUtils.logError(activity, e.toString());
      return null;
    }
    return null;
  }
}

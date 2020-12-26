import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPriview extends StatelessWidget {
  CameraPriview(this.cameraController);
  CameraController cameraController;
  @override
  Widget build(BuildContext context) {
     if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('IMage HEre');
    }
    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }
}

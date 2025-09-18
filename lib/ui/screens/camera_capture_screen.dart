import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 16:9 Aspect Ratio for Camera Preview
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover, // fills 9:16 area, crops instead of stretching
                  child: SizedBox(
                    width: controller!.value.previewSize!.height,
                    height: controller!.value.previewSize!.width,
                    child: CameraPreview(controller!),
                  ),
                ),
              ),
            ),
          ),


          // 🔹 Capture button
          Positioned(
            bottom: 100,
            child: GestureDetector(
              onTap: () async {
                final XFile file = await controller!.takePicture();

                // Go to preview screen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewScreen(imagePath: file.path),
                  ),
                );

                if (result != null && result == true) {
                  Navigator.pop(context, file);
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5), // White outline
                  color: Colors.transparent, // Transparent center
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

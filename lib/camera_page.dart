import 'dart:io';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras; // cameras can be null
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    // Check if cameras is not null and has at least one camera
    if (widget.cameras != null && widget.cameras!.isNotEmpty) {
      controller = CameraController(
        widget.cameras![0], // Use the first camera in the list
        ResolutionPreset.max,
      );

      controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } else {
      // Handle the case where no cameras are available
      print('No camera is found');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras == null ||
        widget.cameras!.isEmpty ||
        !controller.value.isInitialized) {
      // Show a different widget if cameras are not available or not initialized
      return const SizedBox(
        child: Center(
          child:
              Text('No camera found'), // Provide user feedback about no camera
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              height: 400,
              width: 400,
              child: CameraPreview(controller),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              try {
               
                pictureFile = await controller.takePicture();
                setState(() {});
              } catch (e) {
                print(e); 
              }
            },
            child: const Text('Capture Image'),
          ),
        ),
        if (pictureFile != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            // For local files, use Image.file() and ensure the dart:io package is imported
            child: Image.file(
              File(pictureFile!
                  .path), // Use File to load an image from the file path
              height: 200,
            ),
          ),
      ],
    );
  }
}

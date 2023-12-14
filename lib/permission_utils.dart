import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (status.isDenied || status.isRestricted) {
        // Show a dialog explaining the need for camera permissions
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Camera Permission Required'),
            content: Text(
                'This app requires access to the camera to take pictures.'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings(); // Open device settings to enable permissions
                },
              ),
            ],
          ),
        );
      }

      status = await Permission.camera.request();
      return status.isGranted;
    } else {
      return true;
    }
  }
}

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/sensorbar.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController cameraController;
  List<CameraDescription> listCameras;
  CameraDescription _selectedCamera;
  int cameraIndex;
  var _path;

  Future _initCameraController(CameraDescription cameraDescription,
      ResolutionPreset resolutionPreset) async {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + cameraDescription.name);
    print('>>>>>>>>>>>' + resolutionPreset.toString());
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController = CameraController(cameraDescription, resolutionPreset);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    try {
      await cameraController.initialize();
    } on Exception catch (exception) {
      print(exception);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _startVedioRecording() async {
    final Directory appDirectory = await getExternalStorageDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';
    _path = filePath;
    try {
      await cameraController.startVideoRecording(filePath);
      return null;
    } catch (exception) {
      print(exception);
    }

    return filePath;
  }

  Future<String> _stopVedioRec() async {
    try {
      await cameraController.stopVideoRecording().then((value) {
        return value;
      });
    } catch (exception) {
      print(exception);
      return null;
    }
  }


  Widget _cameraList() {
    return DropdownButton(
      hint: Text('Change Camera Here'),
      onChanged: (newValue) {
        setState(() {
          _selectedCamera = newValue;
        });
      },
      items: listCameras.map((CameraDescription _camera) {
        return new DropdownMenuItem(
            value: _camera.name,
            child: FlatButton(
              onPressed: () {
                cameraIndex = int.parse(_camera.name);
                CameraDescription cameraDescription = listCameras[cameraIndex];
                _initCameraController(
                    cameraDescription, ResolutionPreset.medium);
              },
              child: Text(_camera.name),
            ));
      }).toList(),
    );
  }

  var sizeList = ['240p (320x240)', '480p (720x480)', '720p (1280x720)', '1080p (1920x1080)', '2160p (3840x2160)'];
  Widget _sizeList() {
    return DropdownButton(
      hint: Text('Image Size'),
      onChanged: (newValue) {},
      items: sizeList.map((String value) {
        return new DropdownMenuItem(
            value: value,
            child: FlatButton(
              onPressed: () {
                switch (value) {
                  case "240p (320x240)":
                    _initCameraController(
                        listCameras[cameraIndex], ResolutionPreset.low);
                    break;
                  case "480p (720x480)":
                    _initCameraController(
                        listCameras[cameraIndex], ResolutionPreset.medium);
                    break;
                  case "720p (1280x720)":
                    _initCameraController(
                        listCameras[cameraIndex], ResolutionPreset.high);
                    break;
                  case "1080p (1920x1080)":
                    _initCameraController(
                        listCameras[cameraIndex], ResolutionPreset.veryHigh);
                    break;
                  case "2160p (3840x2160)":
                    _initCameraController(
                        listCameras[cameraIndex], ResolutionPreset.ultraHigh);
                    break;
                }
              },
              child: Text(value),
            ));
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      listCameras = value;
      if (listCameras.length > 0) {}
      setState(() {
        cameraIndex = 0;
      });
      _initCameraController(listCameras[cameraIndex], ResolutionPreset.medium)
          .then((void v) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        leading: SensiorBar(),
        shadowColor: Colors.blue,
        elevation: 20,
        title: Text('Camera Sensor'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [_cameraList(), _sizeList()],
          ),
          Expanded(flex: 1, child: CameraPreview(cameraController)),
          Row(
            children: [
              Container(
                  color: Colors.white,
                  child: FlatButton(
                    onPressed: () async {
                      _path = join(
                        (await getExternalStorageDirectory()).path,
                        '${DateTime.now()}.png',
                      );

                      await cameraController.takePicture(_path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DisplayPictureScreen(imagePath: _path),
                        ),
                      );
                    },
                    child: Icon(Icons.camera),
                  )),
              Container(
                  color: Colors.white,
                  child: FlatButton(
                    onPressed: () {
                      _startVedioRecording().then((value) {
                        if (mounted) setState(() {});
                      });
                    },
                    child: Icon(Icons.photo_camera_front),
                  )),
              Container(
                  color: Colors.white,
                  child: FlatButton(
                      onPressed: () async {
                        await cameraController.stopVideoRecording();
                      },
                      child: Icon(
                        Icons.stop_circle,
                      )))
            ],
          )
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
    );
  }
}

import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import '../sensorbar.dart';

class Mike extends StatefulWidget {
  @override
  _MikeState createState() => _MikeState();
}

class _MikeState extends State<Mike> {
  FlutterAudioRecorder _flutterAudioRecorder;
  Recording _recording;
  RecordingStatus _recordingStatus = RecordingStatus.Unset;
  bool _micOn = false;
  bool _micOff = false;
  AudioPlayer audioPlayer;
  String _filePath;

  _init() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      String customPath = '/Sensor_Record ';
      io.Directory appDocDirectory = await getExternalStorageDirectory();

      customPath = appDocDirectory.path +
          customPath +
          DateTime.now().millisecondsSinceEpoch.toString();
      _flutterAudioRecorder =
          FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);
      await _flutterAudioRecorder.initialized;

      var current = await _flutterAudioRecorder.current(channel: 0);
      setState(() {
        _recording = current;
        _recordingStatus = current.status;
      });
    } else {
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("You must accept permissions")));
    }
  }

  _start(int n) async {
    try {
      await _flutterAudioRecorder.start();
      var recording = await _flutterAudioRecorder.current(channel: n);
      setState(() {
        _recording = recording;
      });
      print(recording.status);

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_recordingStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _flutterAudioRecorder.current(channel: n);

        setState(() {
          _recording = current;
          _recordingStatus = _recording.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var result = await _flutterAudioRecorder.stop();
    _filePath = result.path;
    setState(() {
      _recording = result;
      _recordingStatus = _recording.status;
    });
  }

  void initState() {
    super.initState();
    audioPlayer = new AudioPlayer();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        leading: SensiorBar(),
        shadowColor: Colors.blue,
        elevation: 20,
        title: Text('Microphone Sensor'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          _micOn ? Colors.red[400] : Colors.grey[850],
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    onTap: () {
                      _micOn = true;
                      _micOff = false;
                      _start(0);
                    }),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          _micOff ? Colors.red[400] : Colors.grey[850],
                      child: Icon(
                        Icons.mic_off,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    onTap: () {
                      _micOn = false;
                      _micOff = true;
                      _stop();
                    }),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    audioPlayer.play(_filePath, isLocal: true);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[850],
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                FlatButton(
                  onPressed: () {
                    audioPlayer.pause();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[850],
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                FlatButton(
                  onPressed: () {
                    audioPlayer.stop();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[850],
                    child: Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

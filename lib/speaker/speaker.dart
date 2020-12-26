import 'package:flutter/material.dart';

import '../sensorbar.dart';
import 'soundpad.dart';

class Speaker extends StatefulWidget {
  @override
  _SpeakerState createState() => _SpeakerState();
}

class _SpeakerState extends State<Speaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
            backgroundColor: Colors.grey[600],
            leading: SensiorBar(),
            shadowColor: Colors.blue,
            elevation: 20,
            title: Text('Speaker Sensor'),
          ),
      
      body: SoundPad(),
    );
  }
}
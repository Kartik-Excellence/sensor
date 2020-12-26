import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homepage.dart';
import 'sensorbar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(Sensors());
}

class Sensors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App for sensors',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[600],
            leading: SensiorBar(),
            shadowColor: Colors.blue,
            elevation: 20,
            title: Text('Flutter Sensor'),
          ),
          backgroundColor: Colors.black,
          body: HomePage()),
    );
  }
}
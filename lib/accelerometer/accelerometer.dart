import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

import '../sensorbar.dart';

class Accelerometer extends StatefulWidget {
  @override
  _AccelerometerState createState() => _AccelerometerState();
}

class _AccelerometerState extends State<Accelerometer> {
  String x = '0', y = '0', z = '0';
  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[600],
          leading: SensiorBar(),
          shadowColor: Colors.blue,
          elevation: 20,
          title: Text('Accelerometer Sensor'),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      for (StreamSubscription<dynamic> subscription
                          in _streamSubscriptions) {
                        subscription.resume();
                      }
                    },
                    child: Text('start'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      for (StreamSubscription<dynamic> subscription
                          in _streamSubscriptions) {
                        subscription.pause();
                      }
                    },
                    child: Text('stop'),
                  ),
                ],
              ),
              Text(
                'X : ${accelerometer[0]}\nY : ${accelerometer[1]}\nZ : ${accelerometer[2]}',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),

              FlatButton(
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    x = accelerometer[0].toString();
                    y = accelerometer[1].toString();
                    z = accelerometer[2].toString();
                  });
                },
                child: Text('Save'),
              ),
              Text(
                'X : $x\nY : $y\nZ : $z',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }
}

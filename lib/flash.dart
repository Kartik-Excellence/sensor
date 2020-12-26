import 'package:flashlight/flashlight.dart';
import 'package:flutter/material.dart';

import 'sensorbar.dart';


class Flash extends StatefulWidget {
  @override
  _FlashState createState() => _FlashState();
}

class _FlashState extends State<Flash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
            backgroundColor: Colors.grey[600],
            leading: SensiorBar(),
            shadowColor: Colors.blue,
            elevation: 20,
            title: Text('Flash Sensor'),
          ),
          body: Center(
            child: Container(
         margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
            child: Column(
              
              children: [
                 GestureDetector(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[850],
                      child: Icon(
                       Icons.flash_on,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    onTap: () => Flashlight.lightOn(),
                  ),
                    SizedBox(height: 20),
               GestureDetector(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[850],
                      child: Icon(
                       Icons.flash_off,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    onTap: () => Flashlight.lightOff(),
                  ),
              ],
            ),
        
      ),
          ),
    );
  }
}

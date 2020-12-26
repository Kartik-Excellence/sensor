import 'package:flutter/material.dart';

import 'main.dart';

class SensiorBar extends StatefulWidget {
  @override
  _SensiorBarState createState() => _SensiorBarState();
}

class _SensiorBarState extends State<SensiorBar> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 2),
      color: Colors.grey[600],
      child: Icon(Icons.home),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Sensors()));
      },
    );
  }
}

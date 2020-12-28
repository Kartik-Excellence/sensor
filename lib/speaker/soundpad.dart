import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SoundPad extends StatefulWidget {
  @override
  _SoundPadState createState() => _SoundPadState();
}

class _SoundPadState extends State<SoundPad> {
  static const platform = const MethodChannel('com.sensor.speaker');
  final _duration = TextEditingController();
  final _sampleRate = TextEditingController();
  final _freq1 = TextEditingController();
  final _freq2 = TextEditingController();
  var generatedSnd;
  bool _playButton = false;
  Future _genTone(String message) async {
    var sendMap = <String, dynamic>{
      'duration': int.parse(_duration.text),
      'sampleRate': int.parse(_sampleRate.text),
      'freq1': double.parse(_freq1.text),
      'freq2': double.parse(_freq2.text)
    };
    try {
      print(sendMap.entries);
      await platform.invokeMethod(message, sendMap).then((value) {
        setState(() {
          _playButton = true;
        });
        print('Sound Generated');
        generatedSnd = value["generatedSnd"];
      });
    } catch (e) {
      print(e);
    }
  }

  Future _playTone() async {
    var playMap = <String, Object>{
      'sampleRate': int.parse(_sampleRate.text),
      'generatedSnd': generatedSnd
    };
    print(playMap.entries);
    try {
      await platform.invokeMethod("playTone", playMap);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('Duration'),
              Expanded(
                child: TextFormField(
                  controller: _duration,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Sample Rate'),
              Expanded(
                child: TextFormField(
                  controller: _sampleRate,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Frequency 1'),
              Expanded(
                child: TextFormField(
                  controller: _freq1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Frequency 2'),
              Expanded(
                child: TextFormField(
                  controller: _freq2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FlatButton(
              color: Colors.grey,
              textColor: Colors.black,
              onPressed: () async {
                await _genTone("genTone");
              },
              child: Text('Generate'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FlatButton(
              color: _playButton ? Colors.grey : Colors.white,
              textColor: Colors.black,
              onPressed: () async {
                await _playTone();
              },
              child: Text('Play'),
            ),
          ),
        ],
      ),
    );
  }
}

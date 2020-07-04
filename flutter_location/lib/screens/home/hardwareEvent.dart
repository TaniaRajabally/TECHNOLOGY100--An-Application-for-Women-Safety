import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
class HardwareButton extends StatefulWidget {
  @override
  _HardwareButtonState createState() => _HardwareButtonState();
}

class _HardwareButtonState extends State<HardwareButton> {
  String _latestHardwareButtonEvent;

  StreamSubscription<HardwareButtons.VolumeButtonEvent> _volumeButtonSubscription;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<HardwareButtons.LockButtonEvent> _lockButtonSubscription;
  var count=0;
  @override
  void initState() {
    super.initState();
    _volumeButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = event.toString();
      });
    });
    

    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = event.toString();
      });
    });

    _lockButtonSubscription = HardwareButtons.lockButtonEvents.listen((event) {
      setState(() {
        count = count+1;
        _latestHardwareButtonEvent = event.toString();
      });
    });
  }
  // void volume(){
  //   _volumeButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
  //     setState(() {
  //       _latestHardwareButtonEvent = event.toString();
  //       print("in");
  //       count=count+1;
  //     });
  //   });
  // }
  @override
  void dispose() {
    super.dispose();
    _volumeButtonSubscription?.cancel();
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Value: $_latestHardwareButtonEvent\n'),
              Text('Count $count\n'),
            ],
          ),
        ),
      ),
    );
  }
}

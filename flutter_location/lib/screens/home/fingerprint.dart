import 'package:flutter/material.dart';  
//1. imported local authentication plugin  

import 'package:local_auth/local_auth.dart';

import 'dart:async';




class FingerPrint extends StatefulWidget {
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  String _authorizedOrNot = "Not Authorized";  
  Timer _timer;
int _start = 10;
var sendMess = "Yeah";
void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) => setState(
      () {
        if (_start < 1) {
          if(_authorizedOrNot=="Not Authorized" ){
            sendMess = "Yessss";
          }

          
          timer.cancel();
        } else {
          if(_authorizedOrNot=="Authorized" ){
            sendMess = "No";
            timer.cancel();
          }
          _start = _start - 1;
        }
      },
    ),
  );
  setState(() {
    
  });
  
}

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}

 
  final LocalAuthentication _localAuthentication = LocalAuthentication();  
// 3. variable for track whether your device support local authentication means  
//    have fingerprint or face recognization sensor or not  
  bool _hasFingerPrintSupport = false;  
  // 4. we will set state whether user authorized or not  
  
  // 5. list of avalable biometric authentication supports of your device will be saved in this array  
  List<BiometricType> _availableBuimetricType = List<BiometricType>();  

  Future<void> _getBiometricsSupport() async {  
    // 6. this method checks whether your device has biometric support or not  
    bool hasFingerPrintSupport = false;  
    try {  
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;  
    } catch (e) {  
      print(e);  
    }  
    if (!mounted) return;  
    setState(() {  
      _hasFingerPrintSupport = hasFingerPrintSupport;  
    });  
  }  

  Future<void> _getAvailableSupport() async {  
    // 7. this method fetches all the available biometric supports of the device  
    List<BiometricType> availableBuimetricType = List<BiometricType>();  
    try {  
      availableBuimetricType =  
          await _localAuthentication.getAvailableBiometrics();  
    } catch (e) {  
      print(e);  
    }  
    if (!mounted) return;  
    setState(() {  
      _availableBuimetricType = availableBuimetricType;  
    });  
  }  

  Future<void> _authenticateMe() async {  
    // 8. this method opens a dialog for fingerprint authentication.  
    //    we do not need to create a dialog nut it popsup from device natively.  
    bool authenticated = false;  
    try {  
      authenticated = await _localAuthentication.authenticateWithBiometrics(  
        localizedReason: "Authenticate for Testing", // message for dialog  
        useErrorDialogs: true,// show error in dialog  
        stickyAuth: true,// native process  
      ); 
       
    } catch (e) {  
      print(e);  
    }  
    if (!mounted) return;  
    setState(() {  
      _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";  

      

      if(authenticated == true && _start>0){
        sendMess = "No";
      }
      else{
        sendMess = "Yessss";
      }
    });  
  }  

  @override  
  void initState() {  
    _getBiometricsSupport();  
    _getAvailableSupport();  
    super.initState();  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text("Finger Print"),  
      ),  
      body: Center(  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,  
          children: <Widget>[  
            Text("Send Message or Not"),
            Text("$sendMess"),
            RaisedButton(
              onPressed: () {
                    startTimer();
                  },
                  child: Text("start"),
                ),
                Text("$_start"),
                RaisedButton(  
                child: Text("Deactivate Now"),  
                color: Colors.green,  
                onPressed: _authenticateMe,  
              ),  
          ],  
        ),  
      ),  
    );
  }
  
}







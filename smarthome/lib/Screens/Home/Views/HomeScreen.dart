import 'dart:convert';

import 'package:alert_info/alert_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:smarthome/Screens/Device/views/AddDevice.dart';
import 'package:smarthome/Screens/Device/views/DevicesList.dart';
import 'package:smarthome/Screens/Home/Views/MainScreen.dart';
import 'package:smarthome/data/devices.dart';
import 'package:smarthome/models/deviceModel.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {

  int index = 0;
  late List<DeviceModel> devices;
  late stt.SpeechToText _speech;
  int _isListening = 0;
  String _text = "allo";

   void onDeviceInsert(DeviceModel device) async {
      final box = Hive.box<DeviceModel>('devicesBox');

      // Auto-increment ID logic
      final newId = box.isEmpty
          ? 1
          : box.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

      // Create a NEW instance with copied values and new ID
      final newDevice = DeviceModel(
        id: newId,
        typeId: device.typeId,
        name: device.name,
        imageUrl: device.imageUrl,
        imageUrl1: device.imageUrl1,
        color: device.color,
        state: device.state,
        port: device.port,
      );

      await box.add(newDevice);

      setState(() {
        devices = box.values.toList();
      });

      AlertInfo.show(
        context: context,
        text: 'Device Added.',
        typeInfo: TypeInfo.success,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
      );
    }
    void onDeviceDelete(int index) async {
      final box = Hive.box<DeviceModel>('devicesBox');
       box.deleteAt(index);
      setState(() {
        devices = box.values.toList();
      });

      AlertInfo.show(
        context: context,
        text: 'Device Deleted.',
        typeInfo: TypeInfo.success,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
      );
    }

    void onDeviceUpdate(bool state, int index) async {
      final box = Hive.box<DeviceModel>('devicesBox');
      DeviceModel device = box.getAt(index)!;
      device.state = state;
      await device.save();
      Future<dynamic>.delayed(const Duration(seconds: 1));
      state ? AlertInfo.show(
        context: context,
        text: 'Device Turned On.',
        typeInfo: TypeInfo.success,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
      )
      : AlertInfo.show(
        context: context,
        text: 'Device Turned Off.',
        typeInfo: TypeInfo.success,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
      );
    }

  void saveDevice(DeviceModel newDevice) {
    Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
    final int newId = box.isEmpty
      ? 1
      : box.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    newDevice.id = newId;
    box.add(newDevice);
    //  box.deleteAt(0);
  }

 

  String getDeviceName(int index){
    final box = Hive.box<DeviceModel>('devicesBox');
    DeviceModel device = box.getAt(index)!;
    if(device.name.isNotEmpty){
      return device.name;
    }
    return "not found";
  }

  int getDeviceIdByName(String deviceName) {
  Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
  final device = box.values.firstWhere(
    (d) => d.name.toLowerCase() == deviceName.toLowerCase(),
    orElse: () => DeviceModel(id: -1, typeId: -1, name: "", imageUrl: "", imageUrl1: "", color: "", state: false, port: -1),
  );
  return device.id;
  }

  void doAction(String action, String deviceName) {
    int deviceID = getDeviceIdByName(deviceName) - 1;
    if(deviceID == -1){

    }
    else {
      bool state = action.contains("on");
      onDeviceUpdate(state, deviceID);
    }
    Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
    setState(() {
      devices = box.values.toList();
    });
  }

  void _listen() async {
    if (_isListening == 0) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() => _isListening = 1);
        _speech.listen(
          localeId: 'en_US', 
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
            print(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = 2);
      _speech.stop();
        print("sending: $_text ");
        final response = await http.post(
          Uri.parse('http://192.168.11.114:5000/predict_intent'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"text": _text}),
        );
        _isListening = 0;
        var data = jsonDecode(response.body);
        print(data['action']);
        print(data['device_name']);
        doAction(data['action'], data['device_name']);
    }
  }


  @override
  void initState(){
    super.initState();
    Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
    devices = box.values.toList();
    _speech = stt.SpeechToText();
    
    // box.deleteAt(2);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
              toolbarHeight: 10,
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
        bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: 
              BottomNavigationBar(
                enableFeedback: false,
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                      color: index == 0
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey.shade400,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.devices,
                      color: index == 1
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey.shade400,
                    ),
                    label: "Stats",
                  ),
                ],
              ),
              // SalomonBottomBar(
              //   currentIndex: index,
              //   itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              //   backgroundColor: Theme.of(context).colorScheme.secondary,
              //   onTap: (i) => setState(() => index = i),
              //   items: [
              //     /// Home
              //     SalomonBottomBarItem(
              //       icon: Icon(CupertinoIcons.home,
              //        color: index == 0
              //             ? Theme.of(context).colorScheme.onSurface
              //             : Colors.grey.shade400,),
              //       title: Text(""),
              //       selectedColor: Theme.of(context).colorScheme.primary,
              //     ),

              //     /// Likes
              //     SalomonBottomBarItem(
              //       icon: Icon(Icons.devices,
              //        color: index == 1
              //             ? Theme.of(context).colorScheme.onSurface
              //             : Colors.grey.shade400,),
              //       title: Text(""),
              //       selectedColor: Theme.of(context).colorScheme.primary,
              //     ),
              //   ],
              // ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              heroTag: "fab1",
              onPressed: () async {
                  // Navigator.push(
                  // context,
                  // MaterialPageRoute<void>(
                  //   builder: (BuildContext context) =>
                  //       Adddevice(onDeviceInsert: onDeviceInsert),
                  // ),
                  // );
                  setState(() {
                    if(_isListening == 0) {
                      AlertInfo.show(
                      context: context,
                      text: 'Tap again to stop recording.',
                      typeInfo: TypeInfo.info,
                      backgroundColor: Colors.white,
                      textColor: Colors.grey.shade800,
                      iconColor: Colors.blue,
                    );
                    }
                  });
                   _listen();
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: _isListening == 0
                // ? Padding(
                //   padding: const EdgeInsets.only(left: 6),
                //   child: Lottie.asset('assets/images/mic.json'),
                // )
                ?Icon(Icons.mic, size: 25,)
                : _isListening == 1 
                ?LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 20,
                  )
                :_isListening == 2
                ? LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.white,
                    size: 20,
                  )
                : Container()
              ),
            ),
            body: index == 0
                ? Mainscreen(devices: devices, onDeviceUpdate: onDeviceUpdate,)
                : Deviceslist(devices: devices, onDeviceDelete: onDeviceDelete, onDeviceInsert: onDeviceInsert,)
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alert_info/alert_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:record/record.dart';
import 'package:smarthome/Screens/Device/views/DevicesList.dart';
import 'package:smarthome/Screens/Home/Views/MainScreen.dart';
import 'package:smarthome/Screens/Home/Views/Register.dart';
import 'package:smarthome/models/deviceModel.dart';
import 'package:smarthome/models/userModel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {

  late Usermodel user;
  final record = AudioRecorder();
  int index = 0;
  late List<DeviceModel> devices = [];
  int _isListening = 0;
  bool isreloading = true;
  bool isloading = false;
  bool isFound = false;
  String ipAddress = '';
  late AudioPlayer _player;
  bool warning = true;
  // String _text = "turn on the living room lights";
  
  void saveUserData(Map<String, dynamic> userData) {
    final box = Hive.box('userBox');
    box.put('user', userData);
  }
  
  Map<String, dynamic>? getUserData() {
      final box = Hive.box('userBox');
      return Map<String, dynamic>.from(box.get('user') ?? {});
  }

  void updateUserData(Map<String, dynamic> updates) {
    final box = Hive.box('userBox');
    final currentData = Map<String, dynamic>.from(box.get('user') ?? {});
    currentData.addAll(updates);
    box.put('user', currentData);
  }

  
  void onUserUpdate(newuser) {
    setState(() {
      updateUserData({'username': newuser.username});
      updateUserData({'email': newuser.email});
      updateUserData({'phonenumber': newuser.phonenumber});
      updateUserData({'gender': newuser.gender});
      updateUserData({'ipAddress': newuser.ipAddress});
      user = newuser;
      ipAddress = user.ipAddress;
    });
    AlertInfo.show(
        context: context,
        text: 'Profile Updated.',
        typeInfo: TypeInfo.success,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
    );
  }

   void onDeviceInsert(DeviceModel device) async {
      setState(() {
        isreloading = true;
      });
      final url = Uri.parse("http://$ipAddress:8000/devices/");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(device.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        devices = await fetchDevices();
        AlertInfo.show(
          context: context,
          text: 'Device Added.',
          typeInfo: TypeInfo.success,
          backgroundColor: Colors.white,
          textColor: Colors.grey.shade800,
      );
      } else {
        AlertInfo.show(
          context: context,
          text: 'Error.',
          typeInfo: TypeInfo.error,
          backgroundColor: Colors.white,
          textColor: Colors.grey.shade800,
      );
      }
       setState(() {
        isreloading = false;
      });
    }
    void onDeviceDelete(String index) async {
      setState(() {
        isreloading = true;
      });
      final response = await http.delete(Uri.parse("http://$ipAddress:8000/devices/$index"));
      if (response.statusCode == 200) {
            devices = await fetchDevices();
             AlertInfo.show(
              context: context,
              text: 'Device Deleted.',
              typeInfo: TypeInfo.success,
              backgroundColor: Colors.white,
              textColor: Colors.grey.shade800,
            );                                                   
      }
      else{
            AlertInfo.show(
            context: context,
            text: 'Error',
            typeInfo: TypeInfo.error,
            backgroundColor: Colors.white,
            textColor: Colors.grey.shade800,
          );
      }
      setState(() {
        isreloading = false;
      });
    
    }

    void onDeviceUpdate(bool state, String index) async {
      final response = await http.put(Uri.parse("http://$ipAddress:8000/devices/$index"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'state': state
            }),
          );
       if (response.statusCode == 200) {
               devices = await fetchDevices();
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
      else{
            AlertInfo.show(
            context: context,
            text: 'Error',
            typeInfo: TypeInfo.error,
            backgroundColor: Colors.white,
            textColor: Colors.grey.shade800,
          );
      }
    }


 

  String getDeviceName(int index){
    final box = Hive.box<DeviceModel>('devicesBox');
    DeviceModel device = box.getAt(index)!;
    if(device.name.isNotEmpty){
      return device.name;
    }
    return "not found";
  }

  Future<String> getDeviceIdByName(String deviceName) async {
   final response = await http.get(
      Uri.parse("http://$ipAddress:8000/devices/name?name=$deviceName"),
   );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
       return data['_id'];                                             
      }
    return '';
  }

  Future<void> doAction(String action, String deviceName) async {
    String deviceID = await getDeviceIdByName(deviceName);
    if(deviceID == ''){
       AlertInfo.show(
        context: context,
        text: 'Device not found. Please provide more details!',
        typeInfo: TypeInfo.error,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
      );
    }
    else {
      bool state = action.contains("on");
      onDeviceUpdate(state, deviceID);
      fetchDevices().then((fetchedDevices) {
          setState(() {
            devices = fetchedDevices;
            isreloading = false;
          });
        });
    }
    setState(() {
      _isListening = 0;
    });
    
  }

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/audio.wav';
      await record.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
    }
  }
  Future<String?> stopRecording() async {
    final path = await record.stop();
    return path;
  }
  Future<void> transcribeAudio(File audioFile) async {
      final dio = Dio();
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioFile.path, filename: 'audio.wav'),
      });

      final response = await dio.post('http://$ipAddress:8000/predict_intent', data: formData);
      final data = response.data;
      print(data);
        if(data['action']!= null){
          if(data['action'].contains('on') || data['action'].contains('off')){
            if(data['device_name'] != null){
              doAction(data['action'], data['device_name']);
            }
          }
          else{
          AlertInfo.show(
            context: context,
            text: 'Device not found. Please provide more details!',
            typeInfo: TypeInfo.error,
            backgroundColor: Colors.white,
            textColor: Colors.grey.shade800,
          );
          setState(() {
            _isListening = 0;
          });
        }
        }
        else{
          AlertInfo.show(
            context: context,
            text: 'Device not found. Please provide more details!',
            typeInfo: TypeInfo.error,
            backgroundColor: Colors.white,
            textColor: Colors.grey.shade800,
          );
          setState(() {
            _isListening = 0;
          });
        }
}

  void _listen() async {
    if (_isListening == 0) {
      await startRecording();
      setState(() {
        _isListening = 1;
      });
    } else {
      setState(() => _isListening = 2);
      String? path = await stopRecording();
      if(path != null){
        final audioFile = File('/data/user/0/com.example.smarthome/cache/audio.wav');
        await transcribeAudio(audioFile);
      }
    }
  }

  void onUserRegister(Usermodel user){
    saveUserData({
      'username': user.username,
      'email': user.email,
      'phonenumber': user.phonenumber,
      'gender': user.gender,
      'ipAddress': user.ipAddress,
    });
     AlertInfo.show(
      context: context,
      text: 'Account created !',
      typeInfo: TypeInfo.success,
      backgroundColor: Colors.white,
      textColor: Colors.grey.shade800,
    );
    final userData = getUserData();
      setState(() {
        user = Usermodel(username: userData?['username'], email: userData?['email'], phonenumber: userData?['phonenumber'], gender: userData?['gender'], ipAddress: userData?['ipAddress']);
        isFound = true;
        ipAddress = user.ipAddress;
        fetchDevices().then((fetchedDevices) {
          setState(() {
            devices = fetchedDevices;
            isreloading = false;
          });
        });
      });
  }
void onRefresh() async {
    connectWS();
    setState(() {
      fetchDevices().then((fetchedDevices) {
          setState(() {
            devices = fetchedDevices;
            isreloading = false;
          });
        });
    });
  }
  Future<List<DeviceModel>> fetchDevices() async {
    late List<DeviceModel> newdevices = [];
    try {
      final response = await http.get(Uri.parse("http://$ipAddress:8000/devices")).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
           List<dynamic> jsonList = json.decode(response.body);
          for (var json in jsonList) {
            setState(() {
              newdevices.add(DeviceModel(id:json['_id'], typeId:json['typeId'], name: json['name'], imageUrl: json['imageUrl'], imageUrl1: json['imageUrl1'], color: json['color'], state: json['state'], port: json['port']));
            });
          }    
        } 
      } on TimeoutException catch (_) {
        AlertInfo.show(
            context: context,
            text: 'Server not responding',
            typeInfo: TypeInfo.error,
            backgroundColor: Colors.white,
            textColor: Colors.grey.shade800,
          );
      } catch (e) {
        print("Error fetching devices: $e");
      }
    return newdevices;
  }

  void connectWS(){
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://$ipAddress:8000/ws'),
    );

    channel.stream.listen((message) {
      print(message);
      if(message == "refresh"){
        setState(() {
          fetchDevices().then((fetchedDevices) {
          setState(() {
            devices = fetchedDevices;
            isreloading = false;
          });
        });
        });
      }
      else if(message=="gasWarning"){
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'You have a gas leak in your kitchen',
          confirmBtnColor: Theme.of(context).colorScheme.primary,
          onConfirmBtnTap: () async {
              final url = Uri.parse("http://$ipAddress:8000/gasAlert");

              final response = await http.post(
                url,
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"alert": "user confirmation"}),
              );
              Navigator.of(context, rootNavigator: true).pop();
          }
        );
      }
    });
  }

  Future<void> _playStartSound(String path) async {
    try {
      await _player.setAsset(path); // or .setUrl(...) for network files
      await _player.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    final userData = getUserData();
    if(userData != null && userData.isNotEmpty) {
      user = Usermodel(username: userData['username'], email: userData['email'], phonenumber: userData['phonenumber'], gender: userData['gender'], ipAddress: userData['ipAddress'] );
      setState(() {
        ipAddress = user.ipAddress;
        isFound = true;
        fetchDevices().then((fetchedDevices) {
          setState(() {
            devices = fetchedDevices;
            isreloading = false;
          });
        });
      });
      connectWS();
      _player = AudioPlayer();
    }
    else{
      user = Usermodel(username: '', email: '', phonenumber: '', gender: '', ipAddress: '');
      setState(() {
        isFound = false;
      });
    }
    
    
  }
  @override
  void dispose(){
    record.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  !isFound
    ? Register(onUserRegister: onUserRegister,)
    : Scaffold(
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
            body: 
              index == 0
                ? Mainscreen(devices: devices, onDeviceUpdate: onDeviceUpdate, onUserUpdate: onUserUpdate, isreloading: isreloading, onRefresh: onRefresh,warning:warning)
                : Deviceslist(devices: devices, onDeviceDelete: onDeviceDelete, onDeviceInsert: onDeviceInsert, user: user,)
    );
  }
}
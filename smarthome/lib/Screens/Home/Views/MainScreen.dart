import 'package:alert_info/alert_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:smarthome/Components/Device.dart';
import 'package:smarthome/Screens/Settings/Views/SettingScreen.dart';
import 'package:smarthome/models/userModel.dart';
import 'package:smarthome/models/deviceModel.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key, required this.devices, required this.onDeviceUpdate});
  final List<DeviceModel> devices;
  final Function(bool state, String index) onDeviceUpdate;
  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  late Usermodel user;
  late List<DeviceModel>  devices;
  


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
      user = newuser;
    });
    AlertInfo.show(
        context: context,
        text: 'Profile Updated.',
        typeInfo: TypeInfo.success,
        backgroundColor: Colors.white,
        textColor: Colors.grey.shade800,
    );
  }

  @override
  void didUpdateWidget(Mainscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the internal list if the parent sends a new one
    if (oldWidget.devices != widget.devices) {
      devices = List.from(widget.devices);
    }
  }
  @override
  void initState() {
    super.initState();
    devices = List.from(widget.devices);
    final userData = getUserData();
    user = Usermodel(username: userData?['username'], email: userData?['email'], phonenumber: userData?['phonenumber'], gender: userData?['gender']);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow[800],
                              ),
                              child: Image( image: user.gender == "male" ? AssetImage('assets/images/male.png') : AssetImage('assets/images/woman.png') , width:40,),
                            ),
                          ],
                        ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                Settingscreen(user: user,onUserUpdate: onUserUpdate,),
                          ),
                          )
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [ 
                          Container(                                
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white
                            ),
                            child:  Icon(CupertinoIcons.settings, color: Theme.of(context).colorScheme.tertiary, size: 25,),
                          ),
                      ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 40,),
               Row(
                 children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Good Morning ${user.username}", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                      Text(widget.devices.isEmpty 
                      ? "No Device is connected"
                      : widget.devices.length ==  1
                      ? "1 Device is connected"
                      : "${widget.devices.length} Devices are connected", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.tertiary),),
                    ],
                     ),
                 ],
               ),
               SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                itemCount: (devices.length / 2).ceil(), // Number of rows
                itemBuilder: (context, index) {
                  int firstIndex = index * 2;
                  int secondIndex = firstIndex + 1;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Device(
                              device: DeviceModel(
                                id: devices[firstIndex].id,
                                typeId: devices[firstIndex].typeId,
                                name: devices[firstIndex].name,
                                imageUrl: devices[firstIndex].imageUrl,
                                imageUrl1: devices[firstIndex].imageUrl1,
                                color: devices[firstIndex].color,
                                state: devices[firstIndex].state,
                                port:  devices[firstIndex].port,
                              ),
                              onDeviceUpdate: widget.onDeviceUpdate,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (secondIndex < devices.length)
                            Expanded(
                              child: Device(
                                device: DeviceModel(
                                  id: devices[secondIndex].id,
                                  typeId: devices[secondIndex].typeId,
                                  name: devices[secondIndex].name,
                                  imageUrl: devices[secondIndex].imageUrl,
                                  imageUrl1: devices[secondIndex].imageUrl1,
                                  color: devices[secondIndex].color,
                                  state: devices[secondIndex].state,
                                  port:  devices[secondIndex].port,
                                ),
                                onDeviceUpdate: widget.onDeviceUpdate,
                              ),
                            )
                          else
                            Expanded(child: Container()), // empty placeholder for uneven items
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            ],
          ),
      ),
    );
  }
}
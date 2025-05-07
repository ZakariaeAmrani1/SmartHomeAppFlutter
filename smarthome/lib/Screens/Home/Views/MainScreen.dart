import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarthome/Components/Device.dart';
import 'package:smarthome/data/user.dart';
import 'package:smarthome/models/userModel.dart';
import 'package:smarthome/data/devices.dart';
import 'package:smarthome/models/deviceModel.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  final Usermodel user = Usermodel(username: userData['username'], email: userData['email'], phonenumber: userData['phonenumber'], gender: userData['gender']);
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
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow[800],
                                  ),
                                ),
                              ],
                            ),
                     Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                          ),
                          child: Icon(CupertinoIcons.profile_circled, color: Theme.of(context).colorScheme.tertiary, size: 22,),
                        ),
                      ],
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
                      Text("4 Devices are connected", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.tertiary),),
                    ],
                                 ),
                 ],
               ),
               SizedBox(height: 20,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Device(device: DeviceModel(id: devicesData[0]['id'],name: devicesData[0]['name'],imageUrl: devicesData[0]['imageUrl'], color: devicesData[0]['color'], state:  devicesData[0]['state']),),
                  Device(device: DeviceModel(id: devicesData[1]['id'],name: devicesData[1]['name'],imageUrl: devicesData[1]['imageUrl'], color: devicesData[1]['color'], state:  devicesData[1]['state']),),
                ],
               ),
               SizedBox(height: 10,),
                
            ],
          ),
      ),
    );
  }
}
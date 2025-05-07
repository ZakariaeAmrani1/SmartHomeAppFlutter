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
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow[800],
                                  ),
                                  child: Image( image: user.gender == "male" ? AssetImage('assets/images/male.png') : AssetImage('assets/images/woman.png') , width:40,),
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
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white
                          ),
                          child: Icon(CupertinoIcons.settings, color: Theme.of(context).colorScheme.tertiary, size: 22,),
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
            Expanded(
              child: ListView.builder(
                itemCount: (devicesData.length / 2).ceil(), // Number of rows
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
                                id: devicesData[firstIndex]['id'],
                                typeId: devicesData[firstIndex]['type_id'],
                                name: devicesData[firstIndex]['name'],
                                imageUrl: devicesData[firstIndex]['imageUrl'],
                                imageUrl1: devicesData[firstIndex]['imageUrl1'],
                                color: devicesData[firstIndex]['color'],
                                state: devicesData[firstIndex]['state'],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (secondIndex < devicesData.length)
                            Expanded(
                              child: Device(
                                device: DeviceModel(
                                  id: devicesData[secondIndex]['id'],
                                  typeId: devicesData[firstIndex]['type_id'],
                                  name: devicesData[secondIndex]['name'],
                                  imageUrl: devicesData[secondIndex]['imageUrl'],
                                  imageUrl1: devicesData[secondIndex]['imageUrl1'],
                                  color: devicesData[secondIndex]['color'],
                                  state: devicesData[secondIndex]['state'],
                                ),
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
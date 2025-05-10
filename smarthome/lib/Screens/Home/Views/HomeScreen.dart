import 'package:alert_info/alert_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:smarthome/Screens/Device/views/AddDevice.dart';
import 'package:smarthome/Screens/Device/views/DevicesList.dart';
import 'package:smarthome/Screens/Home/Views/MainScreen.dart';
import 'package:smarthome/data/devices.dart';
import 'package:smarthome/models/deviceModel.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {

  int index = 0;
  late List<DeviceModel> devices;

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


  @override
  void initState(){
    super.initState();
    Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
    devices = box.values.toList();
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
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        Adddevice(onDeviceInsert: onDeviceInsert),
                  ),
                  );
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(
                  CupertinoIcons.add,
                ),
              ),
            ),
            body: index == 0
                ? Mainscreen(devices: devices, onDeviceUpdate: onDeviceUpdate,)
                : Deviceslist(devices: devices, onDeviceDelete: onDeviceDelete,)
    );
  }
}
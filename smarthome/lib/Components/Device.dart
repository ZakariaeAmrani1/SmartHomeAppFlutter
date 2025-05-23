import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popup_card/popup_card.dart';
import 'package:smarthome/Screens/Device/views/Device.dart';
import 'package:smarthome/models/deviceModel.dart';

class Device extends StatefulWidget {
  const Device({super.key,  required this.index, required this.device, required this.onDeviceUpdate});
  final DeviceModel device;
  final Function( bool state, int index) onDeviceUpdate;
  final int index;
  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {

  int value = 0;
  int? nullableValue;
  late bool positive;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    positive = widget.device.state;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/2.2,
      padding: EdgeInsets.only(left: 8,  right: 8, bottom: 20),
      decoration: BoxDecoration(
        color: Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          PopupItemLauncher(
            tag: widget.device.id,
            popUp: PopUpItem(
              padding: EdgeInsets.all(16), // Padding inside of the card
              color: Colors.white, // Color of the card
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), // Shape of the card
              elevation: 1, // Elevation of the card
              tag: widget.device.id, // MUST BE THE SAME AS IN `PopupItemLauncher`
              child: DeviceScreen(device: widget.device,), // Your custom child widget.
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image(
                    image: widget.device.state ? AssetImage(widget.device.imageUrl1) : AssetImage(widget.device.imageUrl),
                    width: 30,
                    ),
                ),
              ],
            ),
          ),
        Text(widget.device.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),),
        SizedBox(height: (5),),
        Text("40% Luminosity", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.surface),),
        SizedBox(height: 30,),
        AnimatedToggleSwitch<bool>.dual(
              current: widget.device.state,
              first: false,
              second: true,
              spacing: 10.0,
              animationDuration: const Duration(milliseconds: 600),
              style:  ToggleStyle(
                borderColor: Colors.transparent,
                indicatorColor: Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))),
                backgroundColor: Colors.amber,
              ),
              customStyleBuilder: (context, local, global) => ToggleStyle(
                  backgroundGradient: LinearGradient(
                colors:  [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface],
                stops: [
                  global.position -
                      (1 - 2 * max(0, global.position - 0.5)) * 0.5,
                  global.position + max(0, 2 * (global.position - 0.5)) * 0.5,
                ],
              )),
              borderWidth: 4.0,
              height: 40.0,
              indicatorSize: Size.fromWidth(30),
              loadingIconBuilder: (context, global) =>
                  CupertinoActivityIndicator(
                      color: Color.lerp(
                          Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface, global.position)),
              onChanged: (b) {
                setState(() => widget.device.state = b);
                widget.onDeviceUpdate(b, widget.index);
                return Future<dynamic>.delayed(const Duration(milliseconds: 80));
              },
              iconBuilder: (value) => value
                  ?  Icon(Icons.power_outlined,
                      color: Theme.of(context).colorScheme.surface, size: 22.0)
                  :  Icon(Icons.power_settings_new_rounded,
                      color: Theme.of(context).colorScheme.surface, size: 22.0),
            ),
        ],
      ),
    );
  }
}
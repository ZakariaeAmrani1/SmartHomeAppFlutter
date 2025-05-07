import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smarthome/models/deviceModel.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key, required this.device});
  final DeviceModel device;
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late bool positive;
  bool loading = false;
   final List<String> items = [
    'Air Fan',
    'Air Cooler',
    'Air Heating',
  ];
  String? selectedValue;
  @override
  void initState() {
    super.initState();
    positive = widget.device.state;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Row(
              children: [
                   GestureDetector(
                    onTap: () => {
                      Navigator.pop(context)
                    },
                     child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.tertiary, size: 20,),
                        ),
                      ],
                                       ),
                   ),
                   SizedBox(width: 30,),
                   Text(widget.device.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),),
              ],
            ),
            SizedBox(height: 30,),
            SleekCircularSlider(
              min: 16,
              max: 32,
              initialValue: 26,
              appearance: CircularSliderAppearance(
                customColors: CustomSliderColors(
                  progressBarColor: Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))),
                  dotColor: Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))),
                  trackColor: Theme.of(context).colorScheme.surface,
                  hideShadow: true,
                ),
                  customWidths: CustomSliderWidths(
                  progressBarWidth: 10,
                  trackWidth: 10,
                  handlerSize: 10,
                ),
                size: 200,
                angleRange: 270,
                startAngle: 135,
              ),
              innerWidget: (value) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))),
                        shape: BoxShape.circle
                      ),
                      child: Text(
                        '${value.toInt()}°',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onChange: (value) {
                // Optional: handle value change
              },
          ),
          SizedBox(height: 10,),
          Text("Mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.tertiary),),
         
          SizedBox(height: 30,),
          Container(
            decoration: BoxDecoration(
              color: Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))),
              borderRadius: BorderRadius.circular(20), 
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("State", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),),
                 AnimatedToggleSwitch<bool>.dual(
                  current: positive,
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
                    setState(() => positive = b);
                    return Future<dynamic>.delayed(const Duration(seconds: 2));
                  },
                  iconBuilder: (value) => value
                      ?  Icon(Icons.power_outlined,
                          color: Theme.of(context).colorScheme.surface, size: 22.0)
                      :  Icon(Icons.power_settings_new_rounded,
                          color: Theme.of(context).colorScheme.surface, size: 22.0),
                ),
              ],
            ),
          )
          ],
    );
  }
}
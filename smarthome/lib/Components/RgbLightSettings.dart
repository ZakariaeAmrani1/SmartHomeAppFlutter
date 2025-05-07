import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:smarthome/models/deviceModel.dart';

class Rgblightsettings extends StatefulWidget {
  const Rgblightsettings({super.key, required this.device});
  final DeviceModel device;
  @override
  State<Rgblightsettings> createState() => _RgblightsettingsState();
}

class _RgblightsettingsState extends State<Rgblightsettings> {
  late HSVColor color;
  @override
  void initState() {
    super.initState();
    color = HSVColor.fromColor(Color(int.parse(widget.device.color.replaceFirst('#', '0xFF'))));
  }

  void onChanged(HSVColor color) => this.color = color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         WheelPicker(
          color: color,
          onChanged: (value) => super.setState(
            () => onChanged(value),
          ),
        ),
      ],
    );
  }
}
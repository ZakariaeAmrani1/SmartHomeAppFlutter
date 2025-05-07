import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smarthome/models/deviceModel.dart';

class Lightsettings extends StatefulWidget {
  const Lightsettings({super.key, required this.device});
  final DeviceModel device;
  @override
  State<Lightsettings> createState() => _LightsettingsState();
}

class _LightsettingsState extends State<Lightsettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
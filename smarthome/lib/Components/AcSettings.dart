import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smarthome/models/deviceModel.dart';

class Acsettings extends StatefulWidget {
  const Acsettings({super.key, required this.device});
  final DeviceModel device;
  @override
  State<Acsettings> createState() => _AcsettingsState();
}

class _AcsettingsState extends State<Acsettings> {
   String selectedMode = "Air Cooler";
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
          Text("Air Modes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.tertiary),),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15), 
            ),
             child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () => {
                       setState(() {
                        selectedMode = "Air Fan";
                      })
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: selectedMode == "Air Fan" ? Colors.white : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Air Fan", style: TextStyle(
                        color:  Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                 GestureDetector(
                    onTap: () => {
                       setState(() {
                        selectedMode = "Air Cooler";
                      })
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: selectedMode == "Air Cooler" ? Colors.white: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Air Cooler", style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                   GestureDetector(
                    onTap: () => {
                       setState(() {
                        selectedMode = "Air Heating";
                      })
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                      decoration: BoxDecoration(
                        color: selectedMode == "Air Heating" ? Colors.white: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Air Heating", style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ],
              ),
           ),
      ],
    );
  }
}
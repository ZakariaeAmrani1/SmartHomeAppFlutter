import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/models/deviceModel.dart';

class Deviceslist extends StatefulWidget {
  const Deviceslist({super.key, required this.devices});
  final List<DeviceModel> devices;
  @override
  State<Deviceslist> createState() => _DeviceslistState();
}

class _DeviceslistState extends State<Deviceslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                    Text("Devices", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),),
              ],
            ),
             const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.devices.length,
                itemBuilder: (context, int i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(widget.devices[i].color.replaceFirst('#', '0xFF'))),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:  Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image(
                                      image:  AssetImage(widget.devices[i].imageUrl ),
                                      width: 30,
                                      ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  widget.devices[i].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
import 'package:alert_info/alert_info.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smarthome/data/deviceTypes.dart';
import 'package:smarthome/models/deviceModel.dart';

class Adddevice extends StatefulWidget {
  const Adddevice({super.key, required this.onDeviceInsert});
  final Function( DeviceModel device) onDeviceInsert;

  @override
  State<Adddevice> createState() => _AdddeviceState();
}

class _AdddeviceState extends State<Adddevice> {

  late TextEditingController _nameController;
  final TextEditingController textEditingController = TextEditingController();
  String? selectedvalue;
  late DeviceModel device;
  bool readOnly = true;
  bool isloading = false;


  int getDeviceIdByName(String deviceName) {
    Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
    final index = box.values.toList().indexWhere(
      (d) => d.name.toLowerCase() == deviceName.toLowerCase(),
    );
    return index;
  }
  int getDeviceIdByPort(int? port) {
    Box<DeviceModel> box = Hive.box<DeviceModel>('devicesBox');
    final index = box.values.toList().indexWhere(
      (d) => d.port == port,
    );
    return index;
  }

   @override
  void initState() {
    setState(() {
      device = DeviceModel(
      id: 0,
      typeId: 0,
      name: '',
      imageUrl: '',
      imageUrl1: '',
      color : "",
      state : false,
      port: 0,
    );
     _nameController = TextEditingController(text: device.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.tertiary, size: 20,),
                              ),
                            ],
                                             ),
                         ),
                         SizedBox(width: 10,),
                          Text("Add New Device", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),),
                    ],
                  ),
                   const SizedBox(
                    height: 30,
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select a Device',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: devicesTypes
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  onTap: () {
                                    setState(() {
                                        device.typeId = item['id'];
                                        device.name = item['name'];
                                        device.imageUrl = item['imageUrl'];
                                        device.imageUrl1 = item['imageUrl1'];
                                        device.color = item['color'];
                                      });
                                       _nameController = TextEditingController(text: device.name);
                                       readOnly = false;
                                  },
                                  value: item['id'].toString(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Color(int.parse(item['color'].replaceFirst('#', '0xFF'))),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Image(
                                                    image:  AssetImage(item['imageUrl'] ),
                                                    width: 22,
                                                    ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                item['name'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      Theme.of(context).colorScheme.onSurface,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedvalue,
                          onChanged: (String? value) {
                            setState(
                              () {
                                selectedvalue = value;
                              },
                            );
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 45,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 60,
                          ),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 250,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.transparent)]
                                ),
                                ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Search for a Device...',
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    const SizedBox(
                      height: 20,
                    ),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Device Name",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                     Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        readOnly: readOnly,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Device Name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.device_hub,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        onChanged: (value) {
                          setState(() {
                            device.name = value;
                          });
                        },
                      ),
                    ),
                     const SizedBox(
                      height: 20,
                    ),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Port Number",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                     Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        readOnly: readOnly,
                        initialValue: "",
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: 'Port Number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: Colors.grey,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          setState(() {
                            device.port = int.parse(value);
                          });
                        },
                      ),
                    ),
              ],
            ),
             Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if(device.name == '' || device.port == 0)
                  {
                      AlertInfo.show(
                        context: context,
                        text: 'Please fill in all the fields first!',
                        typeInfo: TypeInfo.error,
                        backgroundColor: Colors.white,
                        textColor: Colors.grey.shade800,
                      );
                  } 
                  else {
                    setState(() {
                      isloading = true;
                    });
                    int index = getDeviceIdByName(device.name);
                    int index1 = getDeviceIdByPort(device.port);
                    if(index != -1){
                      AlertInfo.show(
                        context: context,
                        text: 'Device name already in use. Please try another one!',
                        typeInfo: TypeInfo.error,
                        backgroundColor: Colors.white,
                        textColor: Colors.grey.shade800,
                      );
                    }
                    if(index1 != -1){
                       AlertInfo.show(
                        context: context,
                        text: 'Device port already in use. Please try another one!',
                        typeInfo: TypeInfo.error,
                        backgroundColor: Colors.white,
                        textColor: Colors.grey.shade800,
                      );
                    }
                    if(index == -1 && index1 == -1){
                        widget.onDeviceInsert(device);
                        Navigator.pop(context);
                    }
                    setState(() {
                      isloading = false;
                    });
                    
                  }
                    
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isloading 
                    ? LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.white,
                        size: 20,
                     )
                    : Text("Add Device", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
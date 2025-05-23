

import 'package:hive/hive.dart';

part 'deviceModel.g.dart';// Required for the generated adapter

@HiveType(typeId: 0)
class DeviceModel extends HiveObject {
  @HiveField(0)
   String id;

  @HiveField(1)
   int typeId;

  @HiveField(2)
   String name;

  @HiveField(3)
   String imageUrl;

  @HiveField(4)
   String imageUrl1;

  @HiveField(5)
   String color;

  @HiveField(6)
   bool state;

  @HiveField(7)
   int port;

  DeviceModel({
    required this.id,
    required this.typeId,
    required this.name,
    required this.imageUrl,
    required this.imageUrl1,
    required this.color,
    required this.state,
    required this.port,
  });

  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'name': name,
      'imageUrl': imageUrl,
      'imageUrl1': imageUrl1,
      'color': color,
      'state': state,
      'port': port,
    };
  }
}
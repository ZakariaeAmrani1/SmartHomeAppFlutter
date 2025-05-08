import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smarthome/app.dart';
import 'package:smarthome/models/deviceModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // Register adapters BEFORE opening the box
  Hive.registerAdapter(DeviceModelAdapter());

  // Open boxes
  await Hive.openBox('userBox');
  await Hive.openBox<DeviceModel>('devicesBox');
  runApp(const MyApp());
}



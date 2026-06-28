import 'home_page.dart';
import 'audio.dart';
import 'ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(AudioController(), permanent: true);
  Get.put(BleController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Led Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
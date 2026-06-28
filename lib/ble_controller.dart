import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_page.dart';
import 'wrapper.dart';

class BleController extends GetxController {

  static const String _serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String _charUuid    = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  static const int ledMax = 120;

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription? _connectionSubscription;
  final FocusNode focusNode = FocusNode();

  var ledColors = List<Color>.filled(ledMax, Colors.black).obs;
  var lastR = 255.obs;
  var lastG = 255.obs;
  var lastB = 255.obs;

  // --- SCAN ---

  Future<void> scanDevices() async {
    if (!await Permission.locationWhenInUse.request().isGranted) return;
    if (!await Permission.bluetoothScan.request().isGranted) return;
    if (!await Permission.bluetoothConnect.request().isGranted) return;

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 15),
      androidUsesFineLocation: true,
      androidScanMode: AndroidScanMode.lowLatency,
    );
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  // --- CONNEXION ---

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect(timeout: const Duration(seconds: 15));
    connectedDevice = device;

    final services = await device.discoverServices();
    _characteristic = _findCharacteristic(services);

    if (_characteristic == null) {
      Get.snackbar("Erreur", "Service LED introuvable");
      await device.disconnect();
      return;
    }
    Get.to(const ConnectedWrapper());

    _connectionSubscription?.cancel();
    _connectionSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _onDisconnected();
      }
    });
  }

  Future<void> disconnectDevice() async {
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    await connectedDevice?.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    connectedDevice = null;
    _characteristic = null;
    ledColors.assignAll(List.filled(ledMax, Colors.black));
    lastR.value = 255; lastG.value = 255; lastB.value = 255;
    Get.offAll(() => const MyHomePage());
  }

  // --- ENVOI ---

  Future<void> sendColor(String value) async {
    if (_characteristic == null) {
      Get.snackbar("Erreur", "Aucune caractéristique disponible");
      return;
    }
    await _characteristic!.write(value.codeUnits, withoutResponse: false);

    final parts = value.split(',');
    final lower = value.toLowerCase();

    if (lower == "rainbow") {
      lastR.value = 230; lastG.value = 80; lastB.value = 200;
      ledColors.assignAll(List.filled(ledMax, const Color.fromARGB(255, 230, 80, 200)));
    }
    else if (lower == "off") {
      lastR.value = 255; lastG.value = 255; lastB.value = 255;
      ledColors.assignAll(List.filled(ledMax, Colors.black));
    }
    else if (parts.length == 2) {
      lastR.value = 145; lastG.value = 80; lastB.value = 230;
      ledColors.assignAll(List.filled(ledMax, const Color.fromARGB(255, 145, 80, 230)));
    }
    else if (parts.length == 3) {
      lastR.value = int.parse(parts[0]);
      lastG.value = int.parse(parts[1]);
      lastB.value = int.parse(parts[2]);
      ledColors.assignAll(List.filled(ledMax, Color.fromARGB(255, lastR.value, lastG.value, lastB.value)));
    }
    else if (parts.length == 4) {
      lastR.value = int.parse(parts[1]);
      lastG.value = int.parse(parts[2]);
      lastB.value = int.parse(parts[3]);
      final color = Color.fromARGB(255, lastR.value, lastG.value, lastB.value);
      for (final i in _parseLedIndices(parts[0])) {
        if (i >= 0 && i < ledMax) ledColors[i] = color;
      }
    }
    else {
      lastR.value = 255; lastG.value = 255; lastB.value = 255;
      ledColors.assignAll(List.filled(ledMax, Colors.black));
    }
  }

  // --- UTILS ---

  BluetoothCharacteristic? _findCharacteristic(List<BluetoothService> services) {
    for (final service in services) {
      if (service.uuid.toString().toLowerCase() == _serviceUuid) {
        for (final char in service.characteristics) {
          if (char.uuid.toString().toLowerCase() == _charUuid) {
            return char;
          }
        }
      }
    }
    return null;
  }

  List<int> _parseLedIndices(String raw) {
    final result = <int>[];
    for (final group in raw.trim().split(';')) {
      if (group.contains('-')) {
        final bounds = group.split('-');
        final n1 = int.tryParse(bounds[0]) ?? -1;
        final n2 = int.tryParse(bounds[1]) ?? -1;
        if (n1 >= 0 && n2 >= n1) {
          for (int i = n1; i <= n2; i++) {result.add(i);}
        }
      } else {
        final n = int.tryParse(group);
        if (n != null) result.add(n);
      }
    }
    return result;
  }

  Future<void> openTextInput(BuildContext context, dynamic controller) async {
    final textController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 80),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  focusNode: focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: "délai (recommandé : 10 -> 100)",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  await controller.sendColor("${textController.text},arainbow");
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
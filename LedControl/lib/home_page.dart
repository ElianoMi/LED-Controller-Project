import 'ble_controller.dart';
import 'audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final soloud = Get.find<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset("assets/images/ble_logo.png", height: 30,),
              Text(
                "LED Control - BLE Scan",
                style: TextStyle(
                  color: const Color.fromARGB(255, 84, 117, 224),
                  fontFamily: 'Antiqua',
                ),
              ),
            ],
          )
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              opacity: 0.85,
              fit: BoxFit.cover,
            ),
          ),
          child: (GetBuilder<BleController>(
            builder: (BleController controller)
            {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<List<ScanResult>>(
                        stream: controller.scanResults,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final devices = snapshot.data!
                                .where((r) => r.device.platformName.isNotEmpty)
                                .toList();
                            return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: devices.length,
                                  itemBuilder: (context, index) {
                                    final data = devices[index];
                                    return Card(
                                      elevation: 2,
                                      color: const Color.fromARGB(200, 0, 205, 215),
                                      child: ListTile(
                                        title: Text(data.device.platformName),
                                        subtitle: Text(data.device.remoteId.str),
                                        trailing: Text(data.rssi.toString()),
                                        onTap: ()=> controller.connectToDevice(data.device),
                                      ),
                                    );
                                  }),
                            );
                          }else{
                            return Center(child: Text("No Device Found"),);
                          }
                        }),
                    SizedBox(height: 10,),

                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              soloud.nextMusic();
                            },
                            onLongPress: () {
                              soloud.previousMusic();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                        backgroundColor: const Color.fromARGB(95, 200, 15, 50),
                            ),
                            child: Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            controller.scanDevices();
                            // await controller.disconnectDevice();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            textStyle: const TextStyle(fontSize: 30),
                            backgroundColor: const Color.fromARGB(155, 0, 130, 255),
                          ),
                          child: const Text(
                            "SCAN",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),

                        Spacer(),
                        SizedBox(
                          width: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              soloud.pauseMusic();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: const Color.fromARGB(95, 70, 200, 15),
                            ),
                            child: Obx(() => Icon(
                              soloud.isPaused.value ? Icons.play_arrow_rounded : Icons.pause,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              );
            },
          )
        ),
      ),
    );
  }
}
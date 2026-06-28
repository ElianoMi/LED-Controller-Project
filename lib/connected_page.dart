import 'ble_controller.dart';
import 'audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  final BleController controller = Get.find<BleController>();
  final soloud = Get.find<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/ble_logo.png", height: 30,),
            SizedBox(width: 5,),
            Text(
              "Led Controlling Time",
              style: TextStyle(
                color: const Color.fromARGB(255, 82, 116, 226),
                fontFamily: 'Antiqua',
              ),
            ),
          ],
        )
      ),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background1.jpg"),
          opacity: 0.85,
          fit: BoxFit.cover,
        ),
      ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              Text(
                "Choose Color",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 50,
                  fontFamily: 'Frasa',
                ),
              ),
              Spacer(),

              Obx(() => GestureDetector(
                onTap: () async {
                  await controller.sendColor("OFF");
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color.fromARGB(255, controller.lastR.value, controller.lastG.value, controller.lastB.value,),
                  child: Icon(
                    controller.lastR.value == 230 && controller.lastG.value == 80 && controller.lastB.value == 200
                      ? Icons.looks
                      : controller.lastR.value == 145 && controller.lastG.value == 80 && controller.lastB.value == 230
                        ? Icons.star_border_sharp
                        : Icons.power_settings_new,
                    size: 70,
                    color: Colors.white,
                  )
                ),
              )),
              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller.sendColor("255,0,0");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 255, 0, 0),
                    ),
                    child: const Text(
                        "Red Light",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Frasa',
                        ),
                      ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.sendColor("0,255,0");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 0, 255, 0),
                    ),
                    child: const Text(
                        "Green Light",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Frasa',
                        ),
                      ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.sendColor("0,0,255");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 0, 0, 255),
                    ),
                    child: const Text(
                        "Blue Light",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Frasa',
                        ),
                      ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller.sendColor("255,255,0");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 255, 255, 0),
                    ),
                    child: const Text(
                        "Yellow Light",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Frasa',
                        ),
                      ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.sendColor("255,0,255");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 255, 0, 255),
                    ),
                    child: const Text(
                      "Magenta Light",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Frasa',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.sendColor("0,255,255");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 0, 255, 255),
                    ),
                    child: const Text(
                      "Cyan Light",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Frasa',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await controller.sendColor("rainbow");
                    },
                    icon: const Icon(Icons.looks),
                    label: const Text(
                      "Rainbow Light",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Frasa',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 230, 80, 200),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await controller.sendColor("50,arainbow");
                    },
                    onLongPress: () => controller.openTextInput(context, controller),
                    icon: const Icon(Icons.star_border_sharp),
                    label: const Text(
                      "Animated Rainbow",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Frasa',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 10),
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(85, 145, 80, 230),
                    ),
                  ),
                ],
              ),

              Spacer(),
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
                  ElevatedButton.icon(
                    onPressed: () async {
                      await controller.disconnectDevice();
                    },
                    label: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 40, 20, 150),
                        fontFamily: 'Frasa',
                      ),
                    ),
                    icon: Icon(Icons.home),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      backgroundColor: const Color.fromARGB(95, 255, 103, 1),
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
                      ),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50), // marge en bas
            ],
          ),
        ),
      ),
    );
  }
}
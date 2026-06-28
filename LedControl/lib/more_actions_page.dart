import 'ble_controller.dart';
import 'audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyNotAppPage extends StatefulWidget {
  const MyNotAppPage({super.key});

  @override
  State<MyNotAppPage> createState() => _MyNotAppPageState();
}

class _MyNotAppPageState extends State<MyNotAppPage> {
  final int ledMax = BleController.ledMax;
  final controller = Get.find<BleController>();
  final soloud = Get.find<AudioController>();

  final List<String> colorPresets = [
    "255,0,0", "0,255,0", "0,0,255",
    "255,255,0", "255,0,255", "0,255,255",
    "0,0,0",
  ];

  final TextEditingController _controller1 = TextEditingController();
  String? text1;
  String? text2;

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Container(
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
                Text(
                  "Choose Color",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 50,
                    fontFamily: 'Frasa',
                  ),
                ),
                SizedBox(height: 20,),

                SizedBox(
                  height: 230,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemCount: ledMax,
                    itemBuilder: (context, index) => Obx(() => ElevatedButton(
                      onPressed: () {
                        List<String> ids = _controller1.text.split(';').where((s) => s.isNotEmpty).toList();
                        ids.contains(index.toString()) 
                          ? ids.remove(index.toString())
                          : ids.add(index.toString());

                        _controller1.text = ids.isEmpty 
                          ? ''
                          : '${ids.join(';')};';

                        _controller1.selection = TextSelection.fromPosition(
                          TextPosition(offset: _controller1.text.length),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.ledColors[index],
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Icon(
                        controller.ledColors[index].red == 230 && controller.ledColors[index].green == 80 && controller.ledColors[index].blue == 200
                        ? Icons.looks
                        : controller.ledColors[index].red == 145 && controller.ledColors[index].green == 80 && controller.ledColors[index].blue == 230
                          ? Icons.star_border_sharp
                          : null,
                        color: Colors.white,
                        size: 25
                      ),
                    ),
                  )),
                ),
                SizedBox(height: 20,),

                SizedBox(
                  width: 300,
                  child: Card(
                    color: Color.fromARGB(75, 255, 255, 255),
                    child: TextField(
                      controller: _controller1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Enter LEDs : \'0-5;15;20-75\'',
                      ),
                      onSubmitted: (String value) async {
                        text1 = value;
                        if (text1?.endsWith(';') ?? false) { text1 = text1!.substring(0, text1!.length - 1);}

                        if (text2 != null) {
                          await controller.sendColor("$text1,$text2");
                          _controller1.clear();
                          text1 = null;
                          text2 = null;
                        }
                      }
                    ),
                  ),
                ),
                SizedBox(height: 10,),

                SizedBox(
                  width: 300,
                  child: Card(
                    color: Color.fromARGB(75, 255, 255, 255),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue value) {
                        if (value.text.isEmpty) return colorPresets;
                        return colorPresets.where((c) => c.startsWith(value.text));
                      },
                      onSelected: (String selection) async {
                        text2 = selection;
                        if (text1 != null) {
                          await controller.sendColor("$text1,$text2");
                          _controller1.clear();
                          text1 = null;
                          text2 = null;
                        }
                      },
                      fieldViewBuilder: (context, fieldController, focusNode, onSubmitted) {
                        return TextField(
                          controller: fieldController,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' Enter Color : \'R,G,B\'',
                          ),
                          onSubmitted: (value) async {
                            text2 = value;
                            if (text1 != null) {
                              await controller.sendColor("$text1,$text2");
                              _controller1.clear();
                              text1 = null;
                              text2 = null;
                            }
                            onSubmitted();
                          },
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                ElevatedButton(
                      onPressed: () async {
                        await controller.sendColor("off");
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 10),
                        padding: EdgeInsets.all(15),
                        backgroundColor: const Color.fromARGB(90, 0, 0, 0),
                      ),
                      child: const Text(
                        "OFF",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Frasa',
                        ),
                      ),
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
                      ),),
                    ),
                  ),
                ],
              ),
                SizedBox(height: 50),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
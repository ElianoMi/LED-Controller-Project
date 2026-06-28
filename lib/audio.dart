import 'package:get/get.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:async';

class AudioController extends GetxController {
  final nbMusic = 4;
  final soloud = SoLoud.instance;
  AudioSource? _music;
  SoundHandle? _handle;
  bool _initialized = false;
  final isPaused = false.obs;
  Timer? _autoNext;
  int compt = 0;

  @override
  void onInit() {
    super.onInit();
    initAudio();
  }

  Future<void> initAudio() async {
    if (_initialized) return;
    
    await soloud.init();
    _music = await soloud.loadAsset(
      'assets/audios/sound$compt.mp3',
      autoDispose: true,
    );
    
    _handle = soloud.play(_music!, volume: 0.3);
    
    soloud.setProtectVoice(_handle!, false);
    
    _initialized = true;
    isPaused.value = false;

    _startAutoNext();
  }

  void _startAutoNext() {
    _autoNext?.cancel();
    _autoNext = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_handle != null && 
          soloud.getActiveVoiceCount() == 0 && 
          !isPaused.value &&
          _initialized) {
        nextMusic();
      }
    });
  }

  void pauseMusic() {
    if (_handle == null) return;
    
    if (isPaused.value) {
      soloud.setPause(_handle!, false);
      isPaused.value = false;
    } 
    else {
      soloud.setPause(_handle!, true);
      isPaused.value = true;
    }
  }

  void nextMusic() async {
    _autoNext?.cancel();

    if (_handle != null) {
      soloud.stop(_handle!);
      _handle = null;
    }
    _music = null;

    compt = (compt + 1) % nbMusic;
    _initialized = false;

    await initAudio();
  }

  void previousMusic() async {
    _autoNext?.cancel();

    if (_handle != null) {
      soloud.stop(_handle!);
      _handle = null;
    }
    _music = null;
    
    compt = (compt + (nbMusic - 1)) % nbMusic;
    _initialized = false;

    await initAudio();
  }

  @override
  void onClose() {
    if (_handle != null) {
      soloud.stop(_handle!);
    }
    super.onClose();
  }
}
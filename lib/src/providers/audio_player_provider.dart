import 'package:flutter/material.dart';

class AudioPlayerProvider with ChangeNotifier {
  bool _playing = false;
  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _currentTime = const Duration(microseconds: 0);
  late AnimationController _animationController;

  String get songDurationFormated => imprimirDuracion(_songDuration);
  String get currentTimeFormated => imprimirDuracion(_currentTime);

  double get porcentajeCompletado {
    double porcentaje = 0;
    if (songDuration.inSeconds > 0) {
      porcentaje = _currentTime.inSeconds / _songDuration.inSeconds;
    }
    return porcentaje;
  }

  bool get playing => _playing;
  AnimationController get animationController => _animationController;
  Duration get songDuration => _songDuration;
  Duration get currentTime => _currentTime;

  set playing(bool playing) {
    _playing = playing;
    notifyListeners();
  }

  set animationController(AnimationController animationController) {
    _animationController = animationController;
  }

  set songDuration(Duration songDuration) {
    _songDuration = songDuration;
    notifyListeners();
  }

  set currentTime(Duration currentTime) {
    _currentTime = currentTime;
    notifyListeners();
  }

  String dosDigitos(int numero) {

    if (numero > 10) return '$numero';
    return '0$numero';
  
  }

  String imprimirDuracion(Duration duration) {

    String minutos = dosDigitos(duration.inMinutes.remainder(60));
    String segundos = dosDigitos(duration.inSeconds.remainder(60));

    return '$minutos:$segundos';
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/providers/providers..dart';
import 'package:music_player/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          Column(
            children: [
              const CustomAppBar(),
              _ImagenDiscoDuracion(),
              _TituloPlay(),
              _Lyrics()
            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * .8,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [Color(0xff33333e), Color(0xff201e28)])),
    );
  }
}

class _Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Expanded(
        child: ListWheelScrollView(
      physics: const BouncingScrollPhysics(),
      itemExtent: 42,
      diameterRatio: 1.5,
      children: lyrics
          .map((line) => Text(line,
              style:
                  TextStyle(fontSize: 20, color: Colors.white.withOpacity(.6))))
          .toList(),
    ));
  }
}

class _TituloPlay extends StatefulWidget {
  @override
  State<_TituloPlay> createState() => _TituloPlayState();
}

class _TituloPlayState extends State<_TituloPlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController controller;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);
    assetsAudioPlayer.open(Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
        autoStart: true, showNotification: true);
    assetsAudioPlayer.currentPosition.listen((duration) {
      audioPlayerProvider.currentTime = duration;
    });

    assetsAudioPlayer.current.listen((playingAudio) {
      audioPlayerProvider.songDuration = playingAudio?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          _CancionInformacion(),
          const Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: const Color(0xfff8cb51),
            onPressed: () {
              if (isPlaying) {
                controller.reverse();
                isPlaying = false;
                audioPlayerProvider.animationController.stop();
              } else {
                controller.forward();
                isPlaying = true;
                audioPlayerProvider.animationController.repeat();
              }
              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetsAudioPlayer.playOrPause();
              }
            },
            child: AnimatedIcon(
              progress: controller,
              icon: AnimatedIcons.play_pause,
            ),
          )
        ],
      ),
    );
  }
}

class _CancionInformacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Far away',
          style: TextStyle(fontSize: 30, color: Colors.white.withOpacity(.8)),
        ),
        Text(
          '-Breaking Benjamin-',
          style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(.5)),
        )
      ],
    );
  }
}

class _ImagenDiscoDuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(top: 70),
      child: Row(
        children: [
          _ImagenDisco(),
          const SizedBox(width: 20),
          _BarraProgreso(),
          const SizedBox(width: 20)
        ],
      ),
    );
  }
}

class _BarraProgreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    var textStyle = TextStyle(color: Colors.white.withOpacity(.4));
    return Column(
      children: [
        Text(audioPlayerProvider.songDurationFormated, style: textStyle),
        const SizedBox(height: 10),
        _Barra(),
        const SizedBox(height: 10),
        Text(audioPlayerProvider.currentTimeFormated, style: textStyle),
      ],
    );
  }
}

class _Barra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return Stack(
      children: [
        Container(
          width: 3,
          height: 230,
          color: Colors.white.withOpacity(.1),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 3,
            height: 230 * audioPlayerProvider.porcentajeCompletado,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ImagenDisco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      width: size.width*.62,
      height: size.width*.62,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Color(0xff484750), Color(0xff1e1c24)])),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (controller) {
                audioPlayerProvider.animationController = controller;
              },
              child: const Image(
                image: AssetImage('assets/aurora.jpg'),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                  color: Colors.black38, shape: BoxShape.circle),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                  color: Color(0xff1c1c25), shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}

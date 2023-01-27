import 'package:flutter/material.dart';
import 'package:music_player/src/pages/pages.dart';
import 'package:music_player/src/providers/providers..dart';
import 'package:music_player/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AudioPlayerProvider()
        ),
      ],
      child: const MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.miTema,
      title: 'Music Player',
      home: const MusicPlayerPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:super_diploma/application/controllers/audio_player_controller.dart';
import 'package:super_diploma/application/screen/chat/widgets/seek_bar.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audio;

  const AudioPlayerWidget({super.key, required this.audio});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with WidgetsBindingObserver {
  late final AudioPlayerController _controller;

  @override
  void initState() {
    _controller = AudioPlayerController(widget.audio);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        StreamBuilder<PlayerState>(
          stream: _controller.playerStateStream,
          builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return SizedBox.square(
                dimension: 30,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                color: Colors.white,
                iconSize: 30,
                onPressed: _controller.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                color: Colors.white,
                iconSize: 30,
                onPressed: _controller.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                color: Colors.white,
                iconSize: 30,
                onPressed: () => _controller.seek(Duration.zero),
              );
            }
          },
        ),
        StreamBuilder(
          stream: _controller.positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _controller.seek,
            );
          },
        ),
      ],
    );
  }
}

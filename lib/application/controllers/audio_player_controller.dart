import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:super_diploma/domain/data/position_data.dart';

class AudioPlayerController {
  final AudioPlayer _player = AudioPlayer();
  final String url;

  AudioPlayerController(this.url) {
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(url);
    } on PlayerException catch (e) {
      print(e.message);
    }
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<PositionData> get positionDataStream =>
      CombineLatestStream.combine3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  void play() => _player.play();

  void pause() => _player.pause();

  void seek(Duration position) => _player.seek(position);

  void replay() => _player.seek(Duration.zero);

  void stop() => _player.stop();

  void dispose() {
    _player.dispose();
  }
}

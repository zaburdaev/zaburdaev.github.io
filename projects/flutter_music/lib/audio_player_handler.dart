import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  List<MediaItem> _queue = [];
  int _currentIndex = 0;

  // Геттеры для стримов состояния
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  MyAudioHandler() {
    _player.playerStateStream.listen((state) {
      _updatePlaybackState();
    });

    _player.positionStream.listen((_) {
      _updatePlaybackState();
    });

    _player.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < _queue.length) {
        mediaItem.add(_queue[index]);
      }
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  void _updatePlaybackState() {
    final state = _player.playerState;
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          state.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
          MediaAction.skipToNext,
          MediaAction.skipToPrevious,
          MediaAction.play,
          MediaAction.pause,
          MediaAction.stop,
        },
        androidCompactActionIndices: const [0, 1, 2],
        playing: state.playing,
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[state.processingState]!,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _currentIndex,
      ),
    );
  }

  Future<void> initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> skipToNext() async {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await playMediaItem(_queue[_currentIndex]);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await playMediaItem(_queue[_currentIndex]);
    }
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    _queue = newQueue;
    queue.add(_queue);
    _currentIndex = 0;
    if (_queue.isNotEmpty) {
      mediaItem.add(_queue[0]);
    }
  }

  Future<void> setUrl(String url) async {
    await _player.setUrl(url);
  }

  Future<void> playMediaItem(MediaItem item) async {
    final index = _queue.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _currentIndex = index;
    }
    await _player.setUrl(item.id);
    final duration = _player.duration;
    final updatedItem = item.copyWith(duration: duration);
    mediaItem.add(updatedItem);
    _queue[_currentIndex] = updatedItem;
    await _player.play();
  }

  // Публичный метод для seek
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}

MyAudioHandler? _handlerInstance;

Future<MyAudioHandler> getAudioHandler() async {
  if (_handlerInstance == null) {
    _handlerInstance = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.music.channel.audio',
        androidNotificationChannelName: 'Music playback',
        androidNotificationOngoing: true,
      ),
    );
    await _handlerInstance!.initAudio();
  }
  return _handlerInstance!;
}
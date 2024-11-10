import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleeppal_update/widgets/relaxingSound/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(songName: 'Rain ASMR', albumArtImagePath: "assets/images/rain.jpg", audioPath: "audio/Rain.mp3"),
    Song(songName: 'Minecraft ASMR Japan', albumArtImagePath: "assets/images/minecraft.jpg", audioPath: "audio/Minecraft_ASMR_Japan.mp3"),
    Song(songName: 'Meditation with water sound', albumArtImagePath: "assets/images/artwork3.jpg", audioPath: "audio/water.mp3"),
  ];
  int? _currentSongIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isPlaying = false;

  PlaylistProvider() {
    listenDuration();
  }

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() async {
    if (_currentSongIndex! < _playlist.length - 1) {
      _currentSongIndex = _currentSongIndex! + 1;
    } else {
      _currentSongIndex = 0;
    }
    play(); // Play the next song
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      // Restart the current song if duration > 2 seconds
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        _currentSongIndex = _playlist.length - 1;
      }
      play(); // Play the previous song
    }
  }

  void listenDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong(); // Play the next song when current song ends
    });
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
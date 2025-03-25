import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';
import 'package:spotify_clone/domain/entity/song/song.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  SongWithFavorite? currentSong; // Update this line

  List<SongWithFavorite> playlist = [];
  int currentIndex = 0;

  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
    });
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
    songPosition = position; // Update posisi lagu
    emit(SongPlayerLoading()); // Memperbarui state jika diperlukan
  }

  void setPlaylist(List<SongWithFavorite> songs, int startIndex) async {
    playlist = songs;
    currentIndex = startIndex;
    await loadSong(playlist[currentIndex]);
    playSong(); // Ensure the song starts playing immediately
  }

  Future<void> loadSong(SongWithFavorite song) async {
    try {
      if (!isClosed) {
        currentSong = song; // Update this line
        await audioPlayer.setUrl(
            '${AppURLs.supabaseSongStorage}${song.song.artist} - ${song.song.title}.mp3'); // Assuming the title is the URL
        emit(SongPlayerLoaded());
      }
    } catch (e) {
      if (!isClosed) {
        emit(SongPlayerFailure());
      }
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  void playSong() {
    if (!audioPlayer.playing) {
      audioPlayer.play();
      emit(SongPlayerLoaded());
    }
  }

  void nextSong() {
    if (currentIndex < playlist.length - 1) {
      currentIndex++;
      loadSong(playlist[currentIndex]);
      playSong(); // Ensure the next song starts playing
    }
  }

  void previousSong() {
    if (currentIndex > 0) {
      currentIndex--;
      loadSong(playlist[currentIndex]);
      playSong(); // Ensure the previous song starts playing
    }
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  @override
  Future<void> close() async {
    await audioPlayer.dispose();
    return super.close();
  }

  void stopSong() {
    audioPlayer.stop();
    emit(SongPlayerLoading());
  }
}

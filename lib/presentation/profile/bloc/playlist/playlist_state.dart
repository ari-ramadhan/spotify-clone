import 'package:spotify_clone/domain/entity/playlist/playlist.dart';

abstract class PlaylistState {}

class PlaylistLoading extends PlaylistState{}
class PlaylistLoaded extends PlaylistState{
  final List<PlaylistEntity> playlistModel;

  PlaylistLoaded({required this.playlistModel});
}
class PlaylistFailure extends PlaylistState{}

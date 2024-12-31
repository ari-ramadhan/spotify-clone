import 'package:spotify_clone/domain/entity/album/album.dart';

abstract class AlbumListState {}

class AlbumListLoading extends AlbumListState{}
class AlbumListLoaded extends AlbumListState{

  final List<AlbumEntity> albumEntity;

  AlbumListLoaded({required this.albumEntity});

}
class AlbumListFailure extends AlbumListState{}

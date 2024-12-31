import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/domain/usecases/album/get_artist_album.dart';
import 'package:spotify_clone/presentation/artist_page/bloc/album/album_list_state.dart';

class AlbumListCubit extends Cubit<AlbumListState> {
  AlbumListCubit() : super(AlbumListLoading());

  Future<void> getAlbum(int artistId) async {
    var album = await sl<GetArtistAlbumUseCase>().call(params: artistId);

    album.fold(
      (l) {
        emit(AlbumListFailure());
      },
      (albumEntity) {
        emit(AlbumListLoaded(albumEntity: albumEntity));
      },
    );
  }
}

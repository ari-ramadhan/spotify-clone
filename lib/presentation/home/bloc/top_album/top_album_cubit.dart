import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/domain/usecases/album/get_top_albums.dart';
import 'package:spotify_clone/domain/usecases/artist/hot_artists.dart';
import 'package:spotify_clone/presentation/home/bloc/hot_artists/hot_artists_state.dart';
import 'package:spotify_clone/presentation/home/bloc/top_album/top_album_state.dart';
import 'package:spotify_clone/service_locator.dart';

class TopAlbumsCubit extends Cubit<TopAlbumsState> {
  TopAlbumsCubit() : super(TopAlbumsLoading());

  Future<void> getTopAlbums() async {
    var returnetAlbums = await sl<GetTopAlbumsUseCase>().call();

    await Future.delayed(const Duration(milliseconds: 500));

    returnetAlbums.fold(
      (l) {
        emit(TopAlbumsLoadFailure());
      },
      (data) {
        if (!isClosed) {
          emit(TopAlbumsLoaded(albums: data));
        }
      },
    );
  }
}

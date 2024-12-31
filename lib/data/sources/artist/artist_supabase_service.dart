import 'package:dartz/dartz.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/data/models/artist/artist.dart';
import 'package:spotify_clone/data/models/song/song.dart';
import 'package:spotify_clone/domain/entity/artist/artist.dart';

abstract class ArtistSupabaseService {
  Future<Either> getArtistInfo(int artistId);
  Future<Either> getAllArtist();
}

class ArtistSupabaseServiceImpl extends ArtistSupabaseService {
  @override
  Future<Either> getArtistInfo(int artistId) async {
    try {
      ArtistEntity? artistEntity;

      var data = await supabase.from('artist').select('*').eq('id', artistId);

      ArtistModel artistModel = ArtistModel.fromJson(data.first);
      artistEntity = artistModel.toEntity();

      print(artistEntity.name);

      return Right(artistEntity);
    } catch (e) {
      return Left('error occured when ');
    }
  }

  @override
  Future<Either> getAllArtist() async {
    try {
      List<ArtistEntity> artistList = [];

      var result = await supabase.from('artist').select('*');

      final List<ArtistModel> data = result.map((item) {
        return ArtistModel.fromJson(item);
      }).toList();

      for (final artistModel in data) {
        artistList.add(artistModel.toEntity());
      }

      return Right(artistList);
    } catch (e) {
      return Left('error occured when fetching artist list');
    }
  }
}

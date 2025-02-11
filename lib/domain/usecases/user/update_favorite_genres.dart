import 'package:dartz/dartz.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/domain/repository/user/user.dart';
import 'package:spotify_clone/service_locator.dart';

class UpdateFavoriteGenresUseCase implements Usecase<Either , List> {
  @override
  Future<Either> call({List ? params}) async {
    return await sl<UserRepository>().updateFavoriteGenres(params!);
  }

}

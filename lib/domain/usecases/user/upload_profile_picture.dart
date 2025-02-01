import 'dart:io';

import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_clone/domain/repository/user/user.dart';
import 'package:spotify_clone/service_locator.dart';

class UploadProfilePictureUseCase implements Usecase<Either , File> {
  @override
  Future<Either> call({File ? params}) async {
    return await sl<UserRepository>().uploadImageStorage(params!);
  }

}

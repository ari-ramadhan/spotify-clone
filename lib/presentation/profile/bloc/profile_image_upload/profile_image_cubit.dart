import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_image_upload/profile_image_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarCubit extends Cubit<AvatarState> {
  final SupabaseClient supabase;
  bool isUploaded = false;

  AvatarCubit(this.supabase) : super(AvatarInitial()) {
    getUserAvatar();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final currentState = state;
      if (currentState is AvatarLoaded) {
        emit(
          AvatarPicked(
            File(pickedFile.path),
            Image(
              fit: BoxFit.cover,
              height: 90.w,
              width: 90.w,
              image: NetworkImage(
                currentState.imageUrl,
              ),
            ),
          ),
        );
      } else {
        emit(
          AvatarPicked(
            File(pickedFile.path),
            CircleAvatar(
              radius: 46.sp,
              backgroundColor: Colors.grey.shade700,
              child: Icon(
                Icons.person,
                color: Colors.grey,
                size: 70.sp,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> uploadAvatar(File imageFile, String userId) async {
    emit(AvatarUploading());

    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$userId.$fileExt';
      final filePath = 'userProfile/$fileName';
      final fileBytes = await imageFile.readAsBytes();

      await supabase.storage.from('songs').uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      String publicUrl = supabase.storage.from('songs').getPublicUrl(filePath);

      publicUrl = "$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}";

      var count = await supabase.from('avatar').select().eq('user_id', supabase.auth.currentUser!.id).count();
      if (count.count == 0) {
        await supabase.from('avatar').insert({'user_id': userId, 'avatarUrl': publicUrl});
      }
      await supabase.from('avatar').update({'avatarUrl': publicUrl}).eq('user_id', userId);
      isUploaded = true;
      await Future.delayed(const Duration(milliseconds: 1200));

      emit(AvatarLoaded(publicUrl));
    } catch (e) {
      emit(AvatarError(e.toString()));
    }
  }

  Future<String> getUserAvatar() async {
    try {
      print('get user avatar of : ${supabase.auth.currentUser!.id}');

      var response = await supabase.from('avatar').select('avatarUrl').eq('user_id', supabase.auth.currentUser!.id).single().count();

      if (response.data['avatarUrl'] != null) {
        emit(AvatarLoaded(response.data['avatarUrl']));
      } else {
        emit(AvatarInitial());
      }
      return response.data['avatarUrl'];
    } catch (e) {
      // if (!isClosed) {
      await Future.delayed(const Duration(milliseconds: 1400)).whenComplete(
        () {
          emit(AvatarInitial());
        },
      );

      return '';
    }
  }

  Future deleteAvatarImage() async {
    try {
      var result = await supabase.from('avatar').select().eq('user_id', supabase.auth.currentUser!.id);

      if (result.isNotEmpty) {
        Uri uri = Uri.parse(result[0]['avatarUrl']);
        String path = uri.path;
        String fileName = path.substring(path.lastIndexOf('/') + 1);
        String realFileName = fileName.split('?')[0];

        await supabase.storage.from('songs').remove(['userProfile/$realFileName']);
        await supabase.from('avatar').delete().eq('user_id', supabase.auth.currentUser!.id);

        emit(AvatarInitial());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

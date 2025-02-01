import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_image_upload/profile_image_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarCubit extends Cubit<AvatarState> {
  final SupabaseClient supabase;

  AvatarCubit(this.supabase) : super(AvatarInitial()) {
    getUserAvatar();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(AvatarPicked(File(pickedFile.path)));
    }
  }

  Future<void> uploadAvatar(File imageFile, String userId) async {
    emit(AvatarUploading());

    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$userId.$fileExt';
      final filePath = 'userProfile/$fileName';
      final fileBytes = await imageFile.readAsBytes();

      // Upload to Supabase Storage
      await supabase.storage.from('songs').uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get the new public URL
      String publicUrl = supabase.storage.from('songs').getPublicUrl(filePath);

      // Append timestamp to force refresh
      publicUrl = "$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}";

      // Save updated avatar URL to database
      // await supabase.from('profiles').update({'avatar_url': publicUrl}).eq('id', userId);

      var count = await supabase.from('avatar').select().eq('user_id', supabase.auth.currentUser!.id).count();
      if (count.count == 0) {
        await supabase.from('avatar').insert({'user_id': userId, 'avatarUrl': publicUrl});
      }
      // // Simpan URL ke database user
      await supabase.from('avatar').update({'avatarUrl': publicUrl}).eq('user_id', userId);
      emit(AvatarUploaded(publicUrl));
    } catch (e) {
      emit(AvatarError(e.toString()));
    }
  }

  // Future<void> uploadAvatar(File imageFile, String userId) async {
  //   emit(AvatarUploading());

  //   try {
  //     final fileExt = imageFile.path.split('.').last;
  //     final fileName = '$userId.$fileExt';
  //     final fileBytes = await imageFile.readAsBytes();

  //     // Upload ke Supabase Storage
  //     await supabase.storage.from('songs').uploadBinary(
  //           "userProfile/$fileName",
  //           fileBytes,
  //           fileOptions: const FileOptions(upsert: true),
  //         );

  //     // Dapatkan URL avatar yang baru
  //     final publicUrl = supabase.storage.from('songs').getPublicUrl('userProfile/${fileName}');

  //     var count = await supabase.from('avatar').select().eq('user_id', supabase.auth.currentUser!.id).count();

  //     if (count.count == 0) {
  //       await supabase.from('avatar').insert({'user_id': userId, 'avatarUrl': publicUrl});
  //     }
  //     // // Simpan URL ke database user
  //     await supabase.from('avatar').update({'avatarUrl': publicUrl}).eq('user_id', userId);

  //     emit(AvatarUploaded(publicUrl));
  //   } catch (e) {
  //     emit(AvatarError(e.toString()));
  //   }
  // }

  Future<void> getUserAvatar() async {
    try {
      var imageUrl = await supabase.from('avatar').select().eq('user_id', supabase.auth.currentUser!.id).single().count();

      if (imageUrl.count == 0) {
        emit(AvatarInitial());
      } else {
        var avatarUrl = imageUrl.data['avatarUrl'];
        emit(AvatarUploaded(avatarUrl));
      }
    } catch (e) {
      emit(AvatarInitial());
    }
  }
}

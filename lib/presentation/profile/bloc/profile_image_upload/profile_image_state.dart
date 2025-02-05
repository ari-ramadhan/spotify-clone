import 'dart:io';
import 'package:flutter/material.dart';

abstract class AvatarState {}

class AvatarInitial extends AvatarState {}

class AvatarLoaded extends AvatarState {
  final String imageUrl;
  AvatarLoaded(this.imageUrl);
}

class AvatarPicked extends AvatarState {
  final File imageFile;
  Widget ? imageUrl;
  AvatarPicked(this.imageFile, this.imageUrl);
}

class AvatarUploading extends AvatarState {}

class AvatarError extends AvatarState {
  final String message;
  AvatarError(this.message);
}

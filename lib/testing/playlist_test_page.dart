import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/models/playlist/playlist.dart';
import 'package:spotify_clone/presentation/profile/pages/export.dart';

class PlaylistTestPage extends StatefulWidget {
  final PlaylistEntity playlistModel;
  const PlaylistTestPage({super.key, required this.playlistModel});

  @override
  _PlaylistTestPageState createState() => _PlaylistTestPageState();
}

class _PlaylistTestPageState extends State<PlaylistTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistModel.name ?? 'Playlist Test Page'),
      ),
      body: Expanded(
        child: OutlinedButton(
          onPressed: () async{
            await context.read<PlaylistCubit>().deletePlaylist(widget.playlistModel.id!);
            Navigator.pop(context);
          },
          child: const Text(
            'Delete Playlist',
          ),
        ),
      ),
    );
  }
}

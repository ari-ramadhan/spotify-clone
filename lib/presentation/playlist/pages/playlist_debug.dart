// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
// import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';
// import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_cubit.dart';
// import 'package:spotify_clone/presentation/profile/bloc/favorite_song/favorite_song_state.dart';

// class PlaylistDebug extends StatefulWidget {
//   final String playlistId;

//   PlaylistDebug({required this.playlistId});

//   @override
//   State<PlaylistDebug> createState() => _PlaylistDebugState();
// }

// class _PlaylistDebugState extends State<PlaylistDebug> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose(); // Clean up controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Playlist Songs'),
//       ),
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => FavoriteSongCubit()..getFavoriteSongs(),
//           ),
//           BlocProvider(
//             create: (context) => PlaylistSongsCubit()..getPlaylistSongs(widget.playlistId),
//           ),
//         ],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Playlist Songs',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
//                 builder: (context, state) {
//                   if (state is PlaylistSongsLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is PlaylistSongsLoaded) {
//                     return Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: state.songs.length,
//                             itemBuilder: (context, index) {
//                               final song = state.songs[index];
//                               return ListTile(
//                                 title: Text(song.song.title),
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () {
//                                     context.read<PlaylistSongsCubit>().removeSongFromPlaylist(widget.playlistId, song);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: const Text('Add Song by Keyword'),
//                                   content: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       TextField(
//                                         controller: _controller,
//                                         decoration: const InputDecoration(
//                                           hintText: 'Enter song keyword',
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text('Cancel'),
//                                     ),
//                                     BlocListener<PlaylistSongsCubit, PlaylistSongsState>(
//                                       listener: (context, state) {
//                                         if (state is PlaylistSongsLoaded) {
//                                           Navigator.pop(context); // Dialog ditutup setelah state berhasil diperbarui
//                                         }
//                                       },
//                                       child: ElevatedButton(
//                                         onPressed: () async {
//                                           await context.read<PlaylistSongsCubit>().addSongByKeyword(
//                                                 widget.playlistId,
//                                                 _controller.text,
//                                                 state.songs,
//                                               );
//                                           Navigator.pop(context);
//                                         },
//                                         child: const Text('Add'),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           child: const Text('Add Song'),
//                         ),
//                       ],
//                     );
//                   }
//                   return const Center(child: Text('No songs in the playlist.'));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_cubit.dart';
import 'package:spotify_clone/presentation/playlist/bloc/playlist_songs_state.dart';

class PlaylistDebug extends StatefulWidget {
  final String playlistId;

  PlaylistDebug({required this.playlistId});

  @override
  State<PlaylistDebug> createState() => _PlaylistDebugState();
}

class _PlaylistDebugState extends State<PlaylistDebug> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist Songs'),
      ),
      body: BlocProvider(
        create: (context) => PlaylistSongsCubit()..getPlaylistSongs(widget.playlistId),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Playlist Songs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: BlocBuilder<PlaylistSongsCubit, PlaylistSongsState>(
                builder: (context, state) {
                  if (state is PlaylistSongsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PlaylistSongsLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.songs.length,
                            itemBuilder: (context, index) {
                              final song = state.songs[index];
                              return ListTile(
                                title: Text(song.song.title),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context.read<PlaylistSongsCubit>().removeSongFromPlaylist(widget.playlistId, song);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Add Song by Keyword'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter song keyword',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await context.read<PlaylistSongsCubit>().addSongByKeyword(
                                              widget.playlistId,
                                              _controller.text,
                                              state.songs,
                                            );
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                );
                              },
                            );

                            context.read<PlaylistSongsCubit>().getPlaylistSongs(widget.playlistId);
                          },
                          child: const Text('Add Song'),
                        ),
                      ],
                    );
                  }
                  return const Center(child: Text('No songs in the playlist.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

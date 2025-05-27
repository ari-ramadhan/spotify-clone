import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helpers/export.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/playlist/playlist_state.dart';
import 'package:spotify_clone/testing/playlist_test_page.dart';

class ProfileTestPage extends StatefulWidget {
  const ProfileTestPage({Key? key}) : super(key: key);

  @override
  _ProfileTestPageState createState() => _ProfileTestPageState();
}

class _ProfileTestPageState extends State<ProfileTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Test Page'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'This is a test page for profile functionality.',
              style: TextStyle(fontSize: 20),
            ),
          ),
          BlocBuilder<PlaylistCubit, PlaylistState>(
            builder: (context, state) {
              if (state is PlaylistLoading) {
                return const CircularProgressIndicator();
              } else if (state is PlaylistLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.playlistModel.length,
                  itemBuilder: (context, index) {
                    final playlist = state.playlistModel[index];
                    return ListTile(
                      onTap: () {
                        // Handle playlist tap
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaylistTestPage(
                                playlistModel: playlist,
                              ),
                            ));
                      },
                      title: Text(playlist.name!),
                      subtitle: Text('Total tracks: ${playlist.songCount}'),
                      leading: const Icon(Icons.playlist_play),
                    );
                  },
                );
              } else if (state is PlaylistFailure) {
                return const Text('Error loading playlists}');
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

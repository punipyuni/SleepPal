import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleeppal_update/utils/app_color.utils.dart';
import 'package:sleeppal_update/widgets/relaxingSound/playlist_provider.dart';
import 'package:sleeppal_update/widgets/relaxingSound/song.dart';
import 'package:sleeppal_update/widgets/relaxingSound/song_page.dart';

class RelaxingMusic extends StatefulWidget {
  const RelaxingMusic({super.key});

  @override
  State<RelaxingMusic> createState() => _RelaxState();
}

class _RelaxState extends State<RelaxingMusic> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColor.primaryBackgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              RelaxHeader(),
              Expanded(
                child: Consumer<PlaylistProvider>(
                  builder: (context, value, child) {
                    final List<Song> playlist = value.playlist;
                    return ListView.builder(
                      itemCount: playlist.length,
                      itemBuilder: (context, index) {
                        final Song song = playlist[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
                          child: ListTile(
                            title: Text(
                              song.songName,
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: ClipRRect( // Use ClipRRect for rounded corners
                              borderRadius: BorderRadius.circular(8.0), // Set border radius
                              child: Image.asset(
                                song.albumArtImagePath,
                                width: 50, // Set width for the image
                                height: 50, // Set height for the image
                                fit: BoxFit.cover, // Ensure the image covers the area
                              ),
                            ),
                            onTap: () => goToSong(index),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RelaxHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 16),
          Text(
            'Relaxing Sound',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

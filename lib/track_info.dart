import 'package:flutter/material.dart';
import 'package:flutter_task/bloc.dart';
import 'package:flutter_task/lyrics_model.dart';
import 'package:flutter_task/track_model.dart';

class TrackInfo extends StatefulWidget {
  final String trackId;
  const TrackInfo({Key? key, required this.trackId}) : super(key: key);

  @override
  State<TrackInfo> createState() => _TrackInfoState();
}

class _TrackInfoState extends State<TrackInfo> {
  final blocInstance = Bloc();

  @override
  void initState() {
    blocInstance.eventSink2.add(widget.trackId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Information"),
      ),
      body: StreamBuilder<OnlyTrack>(
        stream: blocInstance.getStream2,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? TrackTile(
                  name: snapshot.data!.trackName,
                  artist: snapshot.data!.artistName,
                  explicit: snapshot.data!.explicit.toString(),
                  rating: snapshot.data!.trackRating.toString(),
                  albumName: snapshot.data!.albumName,
                  lyrics: StreamBuilder<Lyrics>(
                    stream: blocInstance.getStream3,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListTile(
                              title: const Text("Lyrics",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(snapshot.data!.lyricsBody),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class TrackTile extends StatelessWidget {
  final String name, artist, explicit, rating, albumName;
  final Widget lyrics;
  const TrackTile({
    Key? key,
    required this.name,
    required this.artist,
    required this.explicit,
    required this.rating,
    required this.albumName,
    required this.lyrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text(
            "Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            name,
          ),
        ),
        ListTile(
          title: const Text(
            "Artist",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            artist,
          ),
        ),
        ListTile(
          title: const Text(
            "Album Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            albumName,
          ),
        ),
        ListTile(
          title: const Text(
            "Explicit",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            explicit,
          ),
        ),
        ListTile(
          title: const Text(
            "Rating",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            rating,
          ),
        ),
        lyrics
      ],
    );
  }
}

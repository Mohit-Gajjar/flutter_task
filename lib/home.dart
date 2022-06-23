import 'package:flutter/material.dart';
import 'package:flutter_task/bloc.dart';
import 'package:flutter_task/music_model.dart';
import 'package:flutter_task/track_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final blocInstance = Bloc();
  final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  bool isconnected = false;
  void checkConnectivity() async {
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        isconnected = true;
           setState(() {});
        blocInstance.eventSink.add(MusicFetchAction.fetch);
      } else {
        isconnected = false;
           setState(() {});
      }
    });

 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Trending")),
        body: isconnected
            ? StreamBuilder<List<TrackList>>(
                stream: blocInstance.getStream,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrackInfo(
                                            trackId: snapshot
                                                .data![index].track.trackId
                                                .toString())));
                              },
                              title:
                                  Text(snapshot.data![index].track.albumName),
                              subtitle:
                                  Text(snapshot.data![index].track.artistName),
                            );
                          })
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                })
            : const Center(
                child: Text("No Internet Connection"),
              ));
  }
}


// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:flutter_task/constants.dart';
import 'package:flutter_task/lyrics_model.dart';
import 'package:flutter_task/track_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_task/music_model.dart';

enum MusicFetchAction { fetch, none }

class Bloc {
  final _stateStreamController = StreamController<List<TrackList>>();
  StreamSink<List<TrackList>> get _getSink => _stateStreamController.sink;
  Stream<List<TrackList>> get getStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<MusicFetchAction>();
  StreamSink<MusicFetchAction> get eventSink => _eventStreamController.sink;
  Stream<MusicFetchAction> get eventStream => _eventStreamController.stream;

  final _stateStreamController2 = StreamController<OnlyTrack>();
  StreamSink<OnlyTrack> get _getSink2 => _stateStreamController2.sink;
  Stream<OnlyTrack> get getStream2 => _stateStreamController2.stream;

  final _eventStreamController2 = StreamController<String>();
  StreamSink<String> get eventSink2 => _eventStreamController2.sink;
  Stream<String> get eventStream2 => _eventStreamController2.stream;

  final _stateStreamController3 = StreamController<Lyrics>();
  StreamSink<Lyrics> get _getSink3 => _stateStreamController3.sink;
  Stream<Lyrics> get getStream3 => _stateStreamController3.stream;

  final _eventStreamController3 = StreamController<String>();
  StreamSink<String> get eventSink3 => _eventStreamController3.sink;
  Stream<String> get eventStream3 => _eventStreamController3.stream;

  Bloc() {
    eventStream.listen((event) async {
      if (event == MusicFetchAction.fetch) {
        try {
          var music = await fetchMusic();
          _getSink.add(music.message.body.trackList);
        } on Exception catch (e) {
          _getSink.addError("Something went wrong: $e");
        }
      }
    });

    eventStream2.listen((event) async {
      try {
        var track = await fetchMusicTrack(event);
        var lyrics = await fetchMusicTrackLyics(event);
        _getSink2.add(track.message.body.onlyTrack);
        _getSink3.add(lyrics.message.body.lyrics);
      } on Exception catch (e) {
        _getSink2.addError("Something went wrong: $e");
      }
    });
  }
  Future<MusicModel> fetchMusic() async {
    var musicModel;
    try {
      var response = await http.get(Uri.parse(Constants().api1));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        musicModel = MusicModel.fromJson(jsonMap);
      }
    } catch (e) {
      return musicModel;
    }
    return musicModel;
  }

  Future<TrackModel> fetchMusicTrack(String trackId) async {
    var trackModel;
    try {
      var response = await http.get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackId&apikey=f8c10a95dce2ba114c66610e8366b0fe"));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        trackModel = TrackModel.fromJson(jsonMap);
      }
    } catch (e) {
      return trackModel;
    }
    return trackModel;
  }

  Future<LyricsModel> fetchMusicTrackLyics(String trackId) async {
    var lyricsModel;
    try {
      var response = await http.get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=f8c10a95dce2ba114c66610e8366b0fe"));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        lyricsModel = LyricsModel.fromJson(jsonMap);
      }
    } catch (e) {
      return lyricsModel;
    }
    return lyricsModel;
  }
}
// https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=TRACK_ID&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:idb_shim/idb_browser.dart';
import 'sourceinfo.dart';
import 'dart:typed_data';

import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chewie/chewie.dart';
import 'package:universal_html/html.dart' as html;
import 'package:idb_shim/idb.dart';



class DetailsPage extends StatefulWidget  {
  final PlanetInfo planetInfo;

  const DetailsPage({Key? key, required this.planetInfo}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String videoUrl = 'https://res.cloudinary.com/dtlly4vrq/video/upload/f_auto:video,q_auto/v1/closedloop/cpucygayg2gjnfmychuj';

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer('unique_video_id');
  }

    void initializeVideoPlayer(String videoId) async {
    String videoUrl = await loadVideo(videoId);  // Check local storage first
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: false,
            looping: false,
          );
        });
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.planetInfo.name,
                          style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Avenir'),
                          textAlign: TextAlign.left,
                        ),
                        Icon(Icons.all_inclusive,size:36),
                        const Divider(
                          color: Colors.black38,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.planetInfo.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Avenir'),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Divider(
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 10),
                    child: Text(
                      'Videos',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Avenir'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
child: ListView.builder(
  itemCount: widget.planetInfo.images.length,
  scrollDirection: Axis.horizontal,
  itemBuilder: (context, index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              widget.planetInfo.images[index], // Placeholder for thumbnail
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _playVideo(context),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
                child: Icon(Icons.play_arrow, size: 40),
              ),
              SizedBox(height: 8), // Space between buttons
              FutureBuilder<bool>(
                future: isVideoAvailableOffline("unique_video_id"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.data == true) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      
                      decoration: BoxDecoration(
    border: Border.all(
      color: Colors.white,
    ),
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(18))),

                      child:Row(children:[Text('Available offline  ', style:(TextStyle(backgroundColor: Colors.white, fontFamily: "Inter"))),Icon(Icons.cloud_download_outlined)]));
                  } else {
                    return ElevatedButton(
                      onPressed: () => downloadVideo("unique_video_id"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text('Download'),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  },
),
                    ),
                  )
                ],
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            )
          ],
        ),
      ),
    );
  }
Future<bool> isVideoAvailableOffline(String videoId) async {
  try {
    final dbFactory = getIdbFactory();
      final db = await dbFactory!.open('myVideosDB', version: 1, onUpgradeNeeded: (VersionChangeEvent event) {
    final db = event.database;
    // Ensure that the object store is created only if it doesn't already exist
    if (!db.objectStoreNames.contains('videos')) {
      db.createObjectStore('videos', keyPath: 'id');
    }
  });
    final transaction = db.transaction('videos', idbModeReadOnly);
    final store = transaction.objectStore('videos');
    final result = await store.getObject(videoId);
    db.close();
    return result != null;  // True if exists, false otherwise
  } catch (e) {
    print("Error checking video availability: $e");
    return false;  // Assume not available if there's an error
  }
}

void _playVideo(BuildContext context) async {
    if (_chewieController.videoPlayerController.value.isInitialized) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 400,
                child: Chewie(controller: _chewieController),
              ),
            ),
          ),
        ),
      );
    }
  }


Future<void> downloadVideo(String videoId) async {
  final Dio dio = Dio();
  final dbFactory = getIdbFactory();
  final db = await dbFactory!.open('myVideosDB', version: 1, onUpgradeNeeded: (VersionChangeEvent event) {
    final db = event.database;
    // Ensure that the object store is created only if it doesn't already exist
    if (!db.objectStoreNames.contains('videos')) {
      db.createObjectStore('videos', keyPath: 'id');
    }
  });

  try {
    final response = await dio.get<List<int>>(
      videoUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final transaction = db.transaction('videos', idbModeReadWrite);
    final store = transaction.objectStore('videos');
    await store.put({'id': videoId, 'data': response.data});
    await transaction.completed;
    db.close();

    // Notify user of download completion
    _notifyDownloadComplete(context);

    // Reinitialize player with local video
    initializeVideoPlayer(videoId);
  } catch (e) {
    print('Error downloading or storing file: $e');
    db.close();
  }
}

void _notifyDownloadComplete(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Download Complete'),
        content: Text('The video has been successfully downloaded and is now available offline.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  Future<String> loadVideo(String videoId) async {
    final dbFactory = getIdbFactory();
        final db = await dbFactory!.open('myVideosDB', version: 1, onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      db.createObjectStore('videos', keyPath: 'id');
    });

    final transaction = db.transaction('videos', idbModeReadOnly);
    final store = transaction.objectStore('videos');
    final rawResult = await store.getObject(videoId);
    db.close();

    if (rawResult != null) {
      final result = rawResult as Map<String, dynamic>;
      final Uint8List data = result['data'];
      final blob = Blob([data]);
      final url = Url.createObjectUrlFromBlob(blob);
      return url;  // Local blob URL for playback
    } else {
      return videoUrl;  // Fallback to the original network URL
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}



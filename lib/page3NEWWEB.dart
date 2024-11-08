import 'dart:js_interop';
import 'package:web/web.dart' as html;
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb.dart';
import 'package:flutter/foundation.dart';

class Page3NEW extends StatefulWidget {
  @override
  _Page3NEWState createState() => _Page3NEWState();
}

class _Page3NEWState extends State<Page3NEW> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool? videosDownloaded;
    bool isLoading = true; // Add loading flag
  double downloadProgress = 0.0; // New variable for download progress

  final List<Map<String, String>> videoData = [
    {
      'id': 'video1',
      'title': 'LEADING A CARDIAC EMERGENCY',
      'thumbnail': 'assets/thumbnails/closedloop.jpg',
      'video': kIsWeb 
          ? 'assets/newVideos/5clc.mp4'
          : 'assets/newVideos/5clc.mp4'},
    {
      'id': 'video2',
      'title': 'DR ABC Assessment',
      'thumbnail': 'assets/thumbnails/breathingAssess.jpg',
      'video': kIsWeb
          ? 'assets/newVideos/1assessBreathing.mp4'
          : 'assets/newVideos/1assessBreathing.mp4'},
        {
      'id': 'video3',
      'title': 'DR ABC Assessment',
      'thumbnail': 'assets/thumbnails/drabc.jpg',
      'video': kIsWeb
          ? 'assets/newVideos/2drabccardiac.mp4'
          : 'assets/newVideos/2drabccardiac.mp4',
    },
        {
      'id': 'video4',
      'title': 'HOW TO CPR',
      'thumbnail': 'assets/thumbnails/cpr.jpg',
      'video': kIsWeb
          ? 'assets/newVideos/3cpr.mp4'
          : 'assets/newVideos/3cpr.mp4',   
    },
        {
      'id': 'video5',
      'title': 'HOW TO USE A DEFIB',
      'thumbnail': 'assets/thumbnails/defib.jpg',
      'video': kIsWeb 
          ? 'assets/newVideos/4defib.mp4'
          : 'assets/newVideos/4defib.mp4'},
           {
      'id': 'video6',
      'title': 'HOW TO DO RECOVERY POSITION',
      'thumbnail': 'assets/thumbnails/recovery.jpg',
      'video': kIsWeb 
          ? 'assets/newVideos/6recovpos.mp4'
          : 'assets/newVideos/6recovpos.mp4'},

  ];

  @override
  void initState() {
    super.initState();
    _checkIfVideosDownloaded();
  }

Future<void> _checkIfVideosDownloaded() async {
    if (!kIsWeb) return;
    final dbFactory = getIdbFactory();
    final db = await dbFactory!.open('p3VideosDBv1', version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      db.createObjectStore('videos', keyPath: 'id');
    });

    final transaction = db.transaction('videos', idbModeReadOnly);
    final store = transaction.objectStore('videos');

    bool allDownloaded = true;
    for (var video in videoData) {
      final result = await store.getObject(video['id']!);
      if (result == null) {
        allDownloaded = false;
        break;
      }
    }

    setState(() {
      videosDownloaded = allDownloaded;
      isLoading = false;
    });

    db.close();
  }

  Future<void> downloadAllVideos() async {
    final dbFactory = getIdbFactory();
    final db = await dbFactory!.open('p3VideosDBv1', version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      if (!db.objectStoreNames.contains('videos')) {
        db.createObjectStore('videos', keyPath: 'id');
      }
    });

    // Download all videos outside the IndexedDB transaction
    List<Map<String, dynamic>> downloadedVideos = [];

    for (var i=0;i<videoData.length;i++) {
      var video = videoData[i];

          if (kIsWeb && !kDebugMode) {
      video['video'] = video['video']!.replaceFirst('/assets/', '');
    }
      try {
        // Download video
                final response = await Dio().get<List<int>>(
          video['video']!,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                downloadProgress = (received / total) / videoData.length +
                    (i / videoData.length);
              });
            }
          },
          options: Options(responseType: ResponseType.bytes),
        );
        final Uint8List videoBytes = Uint8List.fromList(response.data!);

        // Store the video in memory for now (to avoid IndexedDB transaction issues)
        downloadedVideos.add({'id': video['id'], 'data': videoBytes});
      } catch (e) {
        print('Failed to download video ${video['title']}: $e');
      }
    }

    // Now store each downloaded video in IndexedDB, using a new transaction
    for (var video in downloadedVideos) {
      final transaction =
          db.transaction('videos', idbModeReadWrite); // Open new transaction
      final store = transaction.objectStore('videos');

      try {
        await store.put(video); // Store video in IndexedDB
        await transaction
            .completed; // Ensure transaction completes before moving on
      } catch (e) {
        print('Failed to store video ${video['id']}: $e');
      }
    }

    db.close();
    _notifyDownloadComplete(context);
    // After all videos are downloaded and stored, update the UI
    setState(() {
      videosDownloaded = true;
    });
  }

  void _notifyDownloadComplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Download Complete'),
          content: Text(
              'All videos have been successfully downloaded and are now available offline.'),
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _getMaxWidth(context)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Wrap the GridView with Expanded to give it flexible space
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 16 / 9,
                  ),
                  itemCount: videoData.length,
                  itemBuilder: (context, index) {
                    return _buildVideoCard(videoData[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Download section
                            if (isLoading) ...[
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors
                                          .yellow)), // Show loading spinner
                            ] else if (videosDownloaded == true) ...[
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'All videos available offline  ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Avenir",
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(Icons.cloud_download_outlined,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ] else if (videosDownloaded == false) ...[
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Column(
                                  children: [
                                    if (downloadProgress > 0.0 &&
                                        downloadProgress < 1.0)
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  20), // Add some vertical padding if needed
                                          child: FractionallySizedBox(
                                            widthFactor:
                                                0.33, // Takes 1/3 of the screen width
                                            child: LinearProgressIndicator(
                                              value: downloadProgress,
                                              color: Colors.yellow,
                                              backgroundColor: Colors
                                                  .grey, // Add a background color if desired
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Videos not yet available offline.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontVariations: [FontVariation('wght', (400))],
                                            fontFamily: "NunitoSans",
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: downloadAllVideos,
                                        child: const Text('Download All Videos',
                                            style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              fontVariations: [FontVariation('wght', (400))],
                                            )),
                                      ),
                                  ],
                                ),
                              )
                            ],
            ],
          ),
        ),
      ),
    ),
  );
}

  // Helper function to determine how many columns to show based on screen width
  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3; // 3 columns for wide screens
    if (width > 800) return 2; // 2 columns for medium screens
    return 1; // 1 column for smaller screens
  }

  // Helper function to limit the max width of the content
  double _getMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 1300
        ? 1300
        : width * 0.9; // Max width of 1300px or 90% of screen width
  }

  // Helper function to limit the max width of the button
  double _getButtonMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 600
        ? 400
        : width *
            0.8; // Max width of 400px for the button or 80% of screen width
  }

  Widget _buildVideoCard(Map<String, String> video) {
    return Card(
      color: Color.fromARGB(175, 27, 27, 27),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  video['thumbnail']!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      _playVideo(context, video['id']!, video['video']!),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.black.withOpacity(0.01),
                  ),
                  child: const Icon(Icons.play_arrow,
                      size: 35, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _playVideo(BuildContext context, String videoId, String videoUrl) async {
    String localVideoUrl = await loadVideo(videoId, videoUrl);
    _videoPlayerController = VideoPlayerController.network(localVideoUrl);
      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            autoPlay: true,
            looping: false,
          );
        });
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                ),
              ),
            ),
          ),
        );
      });
  }

  Future<String> loadVideo(String videoId, String videoUrl) async {
    if (!kIsWeb && io.Platform.isAndroid) {
      // For Android, always use the asset video URL
      return videoUrl;
    } else if (kIsWeb) {
      // For web, check if the video is downloaded in IndexedDB
      final dbFactory = getIdbFactory();
      final db = await dbFactory!.open('p3VideosDBv1', version: 1, onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;
        db.createObjectStore('videos', keyPath: 'id');
      });

      final transaction = db.transaction('videos', idbModeReadOnly);
      final store = transaction.objectStore('videos');
      final rawResult = await store.getObject(videoId);
      db.close();

      if (rawResult != null) {
        final result = rawResult as Map<String, dynamic>;
        final Uint8List data = result['data'] as Uint8List;
         if (data != null) {
    // Convert Uint8List to JSUint8Array
    final jsUint8Array = data.toJS;

    // Create a JSArray<JSUint8Array> containing the jsUint8Array
    final jsArray = [jsUint8Array].toJS;

    // Create a BlobPropertyBag with the desired MIME type
    final blobPropertyBag = html.BlobPropertyBag(type: 'video/mp4');

    // Create the Blob using the JSArray and BlobPropertyBag
    final blob = html.Blob(jsArray, blobPropertyBag);

    // Generate a URL for the Blob
    final url = html.URL.createObjectURL(blob);

    return url;
  }
      }
    }
    if (kIsWeb && !kDebugMode) {
    // Modify the path by removing one "/assets/" occurrence
    videoUrl = videoUrl.replaceFirst('/assets/', '');
  }
    return videoUrl; // Fallback to the original network URL if not downloaded
  }
  @override
  void dispose() {
    // Ensure that the controllers are not null before disposing
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

import 'dart:html'
    if (dart.library.io) 'dart:io'; // Conditionally import for platform detection
import 'dart:io' as io show Platform;
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/foundation.dart'; // kIsWeb for web detection
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb.dart';
import 'package:flutter_svg/svg.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class Page2NEW extends StatefulWidget {
  @override
  _Page2NEWState createState() => _Page2NEWState();
}

class _Page2NEWState extends State<Page2NEW> {
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;
  bool videosDownloaded = false;
  int selectedVideoId = 0;
  Color colorButton1 = Color.fromARGB(255, 255, 217, 0);
  Color colorButton2 = Color.fromARGB(255, 255, 217, 0);

  final List<Map<String, String>> videoData = [
    {
      'id': 'video1',
      'title': 'THE PATIENT IS NOT BREATHING',
      'thumbnail': 'assets/drabcThumb.jpg',
      'video': kIsWeb
          ? 'https://res.cloudinary.com/dtlly4vrq/video/upload/v1726746671/closedloop/newVids/Drabccardiac_xblixv.mp4'
          : 'assets/videos/drabccardiac.mp4', // Use asset path for Android
    },
    {
      'id': 'video2',
      'title': 'HOW TO CPR',
      'thumbnail': 'assets/cprThumb.jpg',
      'video': kIsWeb
          ? 'https://res.cloudinary.com/dtlly4vrq/video/upload/v1726746671/closedloop/newVids/Cpr_qwmmm4.mp4'
          : 'assets/videos/cpr.mp4', // Use asset path for Android
    },
    {
      'id': 'video3',
      'title': 'THE PATIENT IS BREATHING',
      'thumbnail': 'assets/assessThumb.jpg',
      'video': kIsWeb
          ? 'https://res.cloudinary.com/dtlly4vrq/video/upload/v1726746672/closedloop/newVids/Patientbreathing_sbaeu9.mp4'
          : 'assets/videos/patientbreathing.mp4', // Use asset path for Android
    },
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _checkIfVideosDownloaded(); // Only check for offline availability on the web
    }
  }

  Future<void> _checkIfVideosDownloaded() async {
    if (!kIsWeb) return; // Skip this check on Android
    final dbFactory = getIdbFactory();
    final db = await dbFactory!.open('myVideosDB', version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      db.createObjectStore('videos', keyPath: 'id');
    });

    final transaction = db.transaction('videos', idbModeReadOnly);
    final store = transaction.objectStore('videos');

    // Check if all videos are downloaded
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
    });

    db.close();
  }

  Future<void> downloadAllVideos() async {
    if (!kIsWeb) return; // Skip downloading on Android

    final dbFactory = getIdbFactory();
    final db = await dbFactory!.open('myVideosDB', version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      if (!db.objectStoreNames.contains('videos')) {
        db.createObjectStore('videos', keyPath: 'id');
      }
    });

    // Download all videos outside the IndexedDB transaction
    List<Map<String, dynamic>> downloadedVideos = [];

    for (var video in videoData) {
      try {
        // Download video
        final response = await Dio().get<List<int>>(video['video']!,
            options: Options(responseType: ResponseType.bytes));
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
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  var padding = MediaQuery.paddingOf(context);
double newheight = screenHeight - padding.top - padding.bottom;
  final double maxWidth = screenWidth > 700 ? 700 : screenWidth;
  final double logoHeight = screenWidth < 500 ? 60 : 90;

  return Scaffold(
    backgroundColor: Colors.transparent,
    body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
      child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[Expanded(child:
Center(
        child: Container(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Image.asset(
                  'assets/newIcon.png',
                  height: logoHeight,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(255, 215, 0, 1),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8 * ScaleSize.textScaleFactor(context)),
                            child: Text(
                              '1',
                              textScaler: TextScaler.linear(1.5 * ScaleSize.textScaleFactor(context)),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Call 999',
                        textScaler: TextScaler.linear(1.5 * ScaleSize.textScaleFactor(context)),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Avenir',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    Container(
                      margin: EdgeInsets.only(left: 13 * ScaleSize.textScaleFactor(context)),
                      width: 2,
                      height: 60,
                      color: Color.fromRGBO(255, 215, 0, 1),
                    ),
                    Row(children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(255, 215, 0, 1),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8 * ScaleSize.textScaleFactor(context)),
                            child: Text(
                              '2',
                              textScaler: TextScaler.linear(1.5 * ScaleSize.textScaleFactor(context)),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Avenir',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Is the patient breathing normally?',
                          softWrap: true,
                          textScaler: TextScaler.linear(1.5 * ScaleSize.textScaleFactor(context)),
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Avenir',
                          ),
                        ),
                      ),
                    ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35 * ScaleSize.textScaleFactor(context), top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorButton1,
                                        padding: EdgeInsets.all(15),
                                      ),
                                      onPressed: () {
                                        _handleBreathingQuestion(true); // Breathing
                                      },
                                      child: Text(
                                        'Yes',
                                        textScaler: TextScaler.linear(1.5 * ScaleSize.textScaleFactor(context)),
                                        style: TextStyle(
                                          fontFamily: 'Avenir-Heavy',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorButton2,
                                        padding: EdgeInsets.all(15),
                                      ),
                                      onPressed: () {
                                        _handleBreathingQuestion(false); // Not Breathing
                                      },
                                      child: Text(
                                        'No',
                                        textScaler: TextScaler.linear(1.5 * ScaleSize.textScaleFactor(context)),
                                        style: TextStyle(
                                          fontFamily: 'Avenir-Heavy',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              if (selectedVideoId != 0) ...[
                                Container(
                                  color: Color.fromARGB(175, 27, 27, 27),
                                  height: 150 * ScaleSize.textScaleFactor(context),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.asset(
                                                videoData[selectedVideoId]['thumbnail']!,
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
                                                onPressed: () => _playVideo(
                                                  context,
                                                  videoData[selectedVideoId]['id']!,
                                                  videoData[selectedVideoId]['video']!,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  shape: const CircleBorder(),
                                                  backgroundColor: Colors.black.withOpacity(0.01),
                                                ),
                                                child: const Icon(Icons.play_arrow, size: 35, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(), // Pushes the offline section to the bottom
              if (!videosDownloaded) ...[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      TextButton(
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Videos not yet available offline. Tap here to download',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Avenir",
                            fontSize: 16,
                          ),
                        ),
                        onPressed: downloadAllVideos,
                      ),
                    ],
                  ),
                )
              ] else ...[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'All videos available offline  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Avenir",
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.cloud_download_outlined, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),)]))));}
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

  void _handleBreathingQuestion(bool isBreathing) {
    if (isBreathing) {
      // Patient is breathing
      setState(() {
        selectedVideoId = 2;
        colorButton1 = Colors.green;
        colorButton2 = Color.fromARGB(255, 255, 217, 0);
      });
    } else {
      // Patient is not breathing
      setState(() {
        selectedVideoId = 1;
        colorButton1 = Color.fromARGB(255, 255, 217, 0);
        colorButton2 = Colors.green;
      });
      // Optionally, show CPR video or handle it differently
      // setState(() {
      //   selectedVideoId = videoData[1]['id'];
      //   selectedVideoUrl = videoData[1]['video'];
      // });
    }
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
    _videoPlayerController2 = VideoPlayerController.network(localVideoUrl);
    _videoPlayerController2!.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController2!,
          aspectRatio: _videoPlayerController2!.value.aspectRatio,
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
                aspectRatio: _videoPlayerController2!.value.aspectRatio,
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
      final db = await dbFactory!.open('myVideosDB', version: 1,
          onUpgradeNeeded: (VersionChangeEvent event) {
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
        final blob = Blob([data], 'video/mp4');
        final url = Url.createObjectUrl(blob);
        return url; // Local blob URL for playback
      }
    }

    return videoUrl; // Fallback to the original network URL if not downloaded
  }

  @override
  void dispose() {
    _videoPlayerController2?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

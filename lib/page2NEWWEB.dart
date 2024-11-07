import 'dart:io' as io show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class Page2NEW extends StatefulWidget {
  const Page2NEW({super.key});

  @override
  State<Page2NEW> createState() => _Page2NEWState();
}

class _Page2NEWState extends State<Page2NEW> {
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;
  bool? videosDownloaded; // Change to nullable bool
  bool isLoading = true; // Add loading flag
  int selectedVideoId = 0;
  double downloadProgress = 0.0; // New variable for download progress
  Color colorButton1 = const Color.fromARGB(255, 255, 217, 0);
  Color colorButton2 = const Color.fromARGB(255, 255, 217, 0);

  final List<Map<String, String>> videoData = [
    {
      'id': 'video1',
      'title': 'THE PATIENT IS NOT BREATHING',
      'thumbnail': 'assets/thumbnails/no.png',
      'video': kIsWeb
          ? 'https://res.cloudinary.com/dtlly4vrq/video/upload/v1730876411/finalRevive/No_Breathing_-_Dr_Abc_Cpr_Aed_dfpfaj.mp4'
          : 'assets/videos/drabccardiac.mp4', // Use asset path for Android
    },
    {
      'id': 'video3',
      'title': 'THE PATIENT IS BREATHING',
      'thumbnail': 'assets/thumbnails/yes.png',
      'video': kIsWeb
          ? 'https://res.cloudinary.com/dtlly4vrq/video/upload/v1730876398/finalRevive/Yes_Breathing_-_Abc_Recovery_Position_kdcuyx.mp4'
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
    if (!kIsWeb) return;
    final dbFactory = getIdbFactory();
    final db = await dbFactory!.open('myVideosDB', version: 1,
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
    if (!kIsWeb) return;

    final dbFactory = getIdbFactory();
    final db = await dbFactory!.open('myVideosDB', version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      final db = event.database;
      if (!db.objectStoreNames.contains('videos')) {
        db.createObjectStore('videos', keyPath: 'id');
      }
    });

    List<Map<String, dynamic>> downloadedVideos = [];

    for (var i = 0; i < videoData.length; i++) {
      var video = videoData[i];
      try {
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
        downloadedVideos.add({'id': video['id'], 'data': videoBytes});
      } catch (e) {
        if (kDebugMode) {
          print('Failed to download video ${video['title']}: $e');
        }
      }
    }

    for (var video in downloadedVideos) {
      final transaction = db.transaction('videos', idbModeReadWrite);
      final store = transaction.objectStore('videos');
      try {
        await store.put(video);
        await transaction.completed;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to store video ${video['id']}: $e');
        }
      }
    }

    db.close();
    setState(() {
      videosDownloaded = true;
      downloadProgress = 0.0; // Reset progress
    });
    if (mounted) {
      _notifyDownloadComplete(context);
    }
  }

  void _notifyDownloadComplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Complete'),
          content: const Text(
              'All videos have been successfully downloaded and are now available offline.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
                    child: Column(children: <Widget>[
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                              child: Image.asset(
                                'assets/newIcon.png',
                                height: logoHeight,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8 *
                                              ScaleSize.textScaleFactor(
                                                  context)),
                                          child: Text(
                                            '1',
                                            textScaler: TextScaler.linear(1.5 *
                                                ScaleSize.textScaleFactor(
                                                    context)),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Avenir',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Call 999',
                                      textScaler: TextScaler.linear(1.5 *
                                          ScaleSize.textScaleFactor(context)),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Avenir',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 13 *
                                            ScaleSize.textScaleFactor(context)),
                                    width: 2,
                                    height: 60,
                                    color: const Color.fromRGBO(255, 215, 0, 1),
                                  ),
                                  Row(children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8 *
                                              ScaleSize.textScaleFactor(
                                                  context)),
                                          child: Text(
                                            '2',
                                            textScaler: TextScaler.linear(1.5 *
                                                ScaleSize.textScaleFactor(
                                                    context)),
                                            style: const TextStyle(
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
                                        textScaler: TextScaler.linear(1.5 *
                                            ScaleSize.textScaleFactor(context)),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 35 *
                                                ScaleSize.textScaleFactor(
                                                    context),
                                            top: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 10, 0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          colorButton1,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    onPressed: () {
                                                      _playVideo(
                                                        context,
                                                        videoData[1]['id']!,
                                                        videoData[1]['video']!,
                                                      );
                                                      // Breathing
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      textScaler: TextScaler
                                                          .linear(1.5 *
                                                              ScaleSize
                                                                  .textScaleFactor(
                                                                      context)),
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Avenir-Heavy',
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        colorButton2,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                  ),
                                                  onPressed: () {
                                                    _playVideo(
                                                      context,
                                                      videoData[0]['id']!,
                                                      videoData[0]['video']!,
                                                    );
                                                    // Breathing
                                                    //_handleBreathingQuestion(false);  Not Breathing
                                                  },
                                                  child: Text(
                                                    'No',
                                                    textScaler:
                                                        TextScaler.linear(1.5 *
                                                            ScaleSize
                                                                .textScaleFactor(
                                                                    context)),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Avenir-Heavy',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            if (selectedVideoId != 0) ...[
                                              Container(
                                                color: const Color.fromARGB(
                                                    175, 27, 27, 27),
                                                height: 150 *
                                                    ScaleSize.textScaleFactor(
                                                        context),
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10)),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Image.asset(
                                                              videoData[
                                                                      selectedVideoId]
                                                                  [
                                                                  'thumbnail']!,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 16,
                                                        right: 16,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  _playVideo(
                                                                context,
                                                                videoData[
                                                                        selectedVideoId]
                                                                    ['id']!,
                                                                videoData[
                                                                        selectedVideoId]
                                                                    ['video']!,
                                                              ),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    const CircleBorder(),
                                                                backgroundColor:
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.01),
                                                              ),
                                                              child: const Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  size: 55,
                                                                  color: Colors
                                                                      .white),
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
                            const Spacer(), // Pushes the offline section to the bottom
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
                                    TextButton(
                                      onPressed: downloadAllVideos,
                                      child: const Text(
                                        textAlign: TextAlign.center,
                                        'Videos not yet available offline. Tap here to download',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Avenir",
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ],
                        ),
                      ),
                    ),
                  )
                ]))));
      }),
    );
  }

  /* void _handleBreathingQuestion(bool isBreathing) {
    if (isBreathing) {
      // Patient is breathing
      setState(() {
        selectedVideoId = 2;
        colorButton1 = Colors.green;
        colorButton2 = const Color.fromARGB(255, 255, 217, 0);
      });
    } else {
      // Patient is not breathing
      setState(() {
        selectedVideoId = 1;
        colorButton1 = const Color.fromARGB(255, 255, 217, 0);
        colorButton2 = Colors.green;
      });
      // Optionally, show CPR video or handle it differently
      // setState(() {
      //   selectedVideoId = videoData[1]['id'];
      //   selectedVideoUrl = videoData[1]['video'];
      // });
    }
  } */

  void _playVideo(BuildContext context, String videoId, String videoUrl) async {
    String localVideoUrl = await loadVideo(videoId, videoUrl);
    _videoPlayerController2 =
        VideoPlayerController.networkUrl(Uri.parse(localVideoUrl));
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
            constraints: const BoxConstraints(maxWidth: 600),
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
        final blob = html.Blob([data], 'video/mp4');
        final url = html.Url.createObjectUrl(blob);
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

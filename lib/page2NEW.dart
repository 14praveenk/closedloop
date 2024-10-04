import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:typed_data';
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
  @override
  _Page2NEWState createState() => _Page2NEWState();
}

class _Page2NEWState extends State<Page2NEW> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool videosDownloaded = false;
  int selectedVideoId = 0;
  MaterialColor colorButton1 = Colors.blueGrey;
  MaterialColor colorButton2 = Colors.blueGrey;

  final List<Map<String, String>> videoData = [
    {
      'id': 'video1',
      'title': 'THE PATIENT IS NOT BREATHING',
      'thumbnail': 'assets/drabcThumb.jpg',
      'video':
          'https://res.cloudinary.com/dtlly4vrq/video/upload/v1726746671/closedloop/newVids/Drabccardiac_xblixv.mp4',
    },
    {
      'id': 'video2',
      'title': 'HOW TO CPR',
      'thumbnail': 'assets/cprThumb.jpg',
      'video':
          'https://res.cloudinary.com/dtlly4vrq/video/upload/v1726746671/closedloop/newVids/Cpr_qwmmm4.mp4',
    },
    {
      'id': 'video3',
      'title': 'THE PATIENT IS BREATHING',
      'thumbnail': 'assets/assessThumb.jpg',
      'video':
          'https://res.cloudinary.com/dtlly4vrq/video/upload/v1726746672/closedloop/newVids/Patientbreathing_sbaeu9.mp4',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkIfVideosDownloaded();
  }

  Future<void> _checkIfVideosDownloaded() async {
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
  return Scaffold(
    backgroundColor: Color.fromARGB(175, 27, 27, 27),
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      title: SvgPicture.asset(
        'assets/newLogo.svg',
        height: 45, // Adjust the height according to your needs
        fit: BoxFit.contain,
      ),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween to push content
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _getMaxWidth(context)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Your existing UI components here...
                  Text(
                    'Step 1: CALL 999',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: 'Avenir-Heavy',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Step 2: Is the patient breathing normally?',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Avenir',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  // Your existing button layout...
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorButton1,
                            padding: EdgeInsets.all(20),
                          ),
                          onPressed: () {
                            _handleBreathingQuestion(true); // Breathing
                          },
                          child: Text(
                            'Patient is Breathing',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Avenir-Heavy',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorButton2,
                            padding: EdgeInsets.all(20),
                          ),
                          onPressed: () {
                            _handleBreathingQuestion(false); // Not Breathing
                          },
                          child: Text(
                            'Patient is Not Breathing',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Avenir-Heavy',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(child: const SizedBox(height: 20)),
                  // Video selection logic...
                  if (selectedVideoId != 0) ...[
                    Container(
                      color: Color.fromARGB(175, 27, 27, 27),
                      height: 200,
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
          ),
        ),
        // This part handles the offline video availability message
        if (!videosDownloaded) ...[
          Container(margin:EdgeInsets.fromLTRB(0, 0, 0, 20),child:Column(children:[
          TextButton(
            child: const Text('Videos not yet available offline. Tap here to download',style: TextStyle(
              color: Colors.white,
                      fontFamily: "Avenir",
              fontSize: 16,
            )),
            onPressed: downloadAllVideos,
          ),            
    ]))] else ...[
          Container(margin:EdgeInsets.fromLTRB(0, 0, 0, 20),child:Column(
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
                      fontSize:16,
                    ),
                  ),
                  Icon(Icons.cloud_download_outlined, color: Colors.white),
                ],
              ),
            ],
          ),),
        ],
      ],
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
        colorButton2 = Colors.blueGrey;
      });
    } else {
      // Patient is not breathing
      setState(() {
        selectedVideoId = 1;
        colorButton1 = Colors.blueGrey;
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
    _videoPlayerController = VideoPlayerController.network(localVideoUrl)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
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
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: _chewieController),
                ),
              ),
            ),
          ),
        );
      });
  }

  Future<String> loadVideo(String videoId, String videoUrl) async {
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
    } else {
      return videoUrl; // Fallback to the original network URL if not downloaded
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

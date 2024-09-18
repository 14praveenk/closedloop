import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:html';
import 'package:idb_shim/idb_browser.dart';
import 'dart:typed_data';

import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chewie/chewie.dart';
import 'package:universal_html/html.dart' as html;
import 'package:idb_shim/idb.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
class Page2NEW extends StatefulWidget  {

  @override
  _Page2NEWState createState() => _Page2NEWState();
}

class _Page2NEWState extends State<Page2NEW> {
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

  final List<Map<String, String>> videoData = [
    {
      'title': 'DR ABC ASSESSMENT',
      'thumbnail': 'https://res.cloudinary.com/dtlly4vrq/image/upload/f_auto,q_auto/v1/closedloop/newThumb/safmyerlh1om6gn5bifh',
    },
    {
      'title': 'HOW TO DO CPR',
      'thumbnail': 'https://res.cloudinary.com/dtlly4vrq/image/upload/f_auto,q_auto/v1/closedloop/newThumb/kfuvoywzrswndbbplglx',
    },
    {
      'title': 'ASSESS A BREATHING PERSON',
      'thumbnail': 'https://res.cloudinary.com/dtlly4vrq/image/upload/f_auto,q_auto/v1/closedloop/newThumb/vbnwkjjo7pcueazpq31y',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 56, 56, 56),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        title: const Text(
          'CPRNow',
          style: TextStyle(
            color: Colors.white,
            fontVariations: [FontVariation('wght', 400)],
            fontFamily: "NunitoSans",
          ),
        ),
        leading: const Icon(Icons.all_inclusive, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _getMaxWidth(context)), // Limit the max width
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: _getButtonMaxWidth(context)), // Limit button width
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 149, 50),
                                Color.fromARGB(255, 203, 44, 44),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Lifesaver Flowchart',
                                          textScaleFactor: 1 * ScaleSize.textScaleFactor(context),
                                          style: const TextStyle(
                                            fontVariations: [FontVariation('wght', 300)],
                                            color: Colors.white,
                                            fontFamily: "NunitoSans",
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Responsive Grid Layout for Videos
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context), // Adjusts based on screen width
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 16 / 9, // Aspect ratio of video cards
                    ),
                    itemCount: videoData.length,
                    itemBuilder: (context, index) {
                      return _buildVideoCard(videoData[index]);
                    },
                  ),
                ],
              ),
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
    if (width > 800) return 2;  // 2 columns for medium screens
    return 1;                    // 1 column for smaller screens
  }

  // Helper function to limit the max width of the content
  double _getMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 1300 ? 1300 : width * 0.9; // Max width of 1300px or 90% of screen width
  }

  // Helper function to limit the max width of the button
  double _getButtonMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 600 ? 600 : width * 0.8; // Max width of 400px for the button or 80% of screen width
  }

  Widget _buildVideoCard(Map<String, String> video) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Stack(
              children: <Widget>[
                Image.network(
                  video['thumbnail']!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: const Color(0xFF000000),
                    ),
                  ),
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
              children: [
                Text(
                  video['title']!,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _playVideo(context),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.black.withOpacity(0.01),
                  ),
                  child: const Icon(Icons.play_arrow, size: 30, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
  final Uint8List data = result['data'] as Uint8List;
  final blob = Blob([data], 'video/mp4');
  final url = Url.createObjectUrl(blob);
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

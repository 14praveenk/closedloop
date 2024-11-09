import 'dart:math';
import 'package:flutter/foundation.dart'; // kIsWeb for web detection
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


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
  bool? videosDownloaded;
  int selectedVideoId = 0;
  Color colorButton1 = const Color.fromARGB(255, 255, 217, 0);
  Color colorButton2 = const Color.fromARGB(255, 255, 217, 0);
  
  final List<Map<String, String>> videoData = [
    {
      'id': 'video1',
      'title': 'THE PATIENT IS NOT BREATHING',
      'thumbnail': 'assets/thumbnails/no.png',
      'video': kIsWeb
          ? 'assets/androidVideos/no.webm'
          : 'assets/androidVideos/no.webm', // Use asset path for Android
    },
    {
      'id': 'video3',
      'title': 'THE PATIENT IS BREATHING',
      'thumbnail': 'assets/thumbnails/yes.png',
      'video': kIsWeb
          ? 'assets/androidVideos/yes.webm'
          : 'assets/androidVideos/yes.webm', // Use asset path for Android
    },
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double logoHeight = screenWidth < 500 ? 60 : 90;
    return Scaffold(
      backgroundColor: const Color.fromARGB(175, 27, 27, 27),
      body: SafeArea(child:SingleChildScrollView(
        child: Column(
          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                        color: Color.fromRGBO(
                            255, 215, 0, 1), // Change color as needed
                      ),
                      child: Center(
                          child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(
                              8 * ScaleSize.textScaleFactor(context)),
                          child: Text(
                            '1',
                            textScaler: TextScaler.linear(
                                1.5 * ScaleSize.textScaleFactor(context)),
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ),
                      )),
                    ),
                    Text(
                      'Call 999',
                      textScaler: TextScaler.linear(
                          1.5 * ScaleSize.textScaleFactor(context)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Avenir',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  Container(
                    margin: EdgeInsets.only(
                        left: 13 * ScaleSize.textScaleFactor(context)),
                    width: 2,
                    height: 60,
                    color: const Color.fromRGBO(255, 215, 0, 1), // Progress bar color
                  ),
                  Row(children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(
                            255, 215, 0, 1), // Change color as needed
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(
                              8 * ScaleSize.textScaleFactor(context)),
                          child: Text(
                            '2',
                            textScaler: TextScaler.linear(
                                1.5 * ScaleSize.textScaleFactor(context)),
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
                      textScaler: TextScaler.linear(
                          1.5 * ScaleSize.textScaleFactor(context)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Avenir',
                      ),
                    ))
                  ]),
                  // Your existing button layout...
                  Row(crossAxisAlignment:CrossAxisAlignment.start,children: [
         //LayoutBuilder(
                        //builder: (context, constraints) {
                          // Calculate remaining height
                          //double screenHeight = MediaQuery.of(context).size.height;
                          //double remainingHeight = screenHeight - 470; // Adjust based on actual height of other widgets

                          //return Container(
                            //margin: EdgeInsets.only(
                          //left: 13 * ScaleSize.textScaleFactor(context)),
                            //width: 2,
                            //height: remainingHeight,
                            //color: Color.fromRGBO(
                              //  255, 215, 0, 1), // Progress bar color
                          //);
                        //}),
                    Container(
                      margin: EdgeInsets.only(
                          left: 35 * ScaleSize.textScaleFactor(context), top:20),
                      child: Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.start,children:[Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorButton1,
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                          _playVideo(
                                                        context,
                                                        videoData[1]['id']!,
                                                        videoData[1]['video']!,
                                                      );
                              },
                              child: Text(
                                'Yes',
                                textScaler: TextScaler.linear(
                                    1.5*ScaleSize.textScaleFactor(context)),
                                style: const TextStyle(
                                  fontFamily: 'Avenir-Heavy',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorButton2,
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                                       _playVideo(
                                                      context,
                                                      videoData[0]['id']!,
                                                      videoData[0]['video']!,
                                                    );
                            },
                            child: Text(
                              'No',
                              textScaler: TextScaler.linear(
                                  1.5*ScaleSize.textScaleFactor(context)),
                              style: const TextStyle(
                                fontFamily: 'Avenir-Heavy',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ), 
                      const SizedBox(height: 20),
                                       // Video selection logic...
                  if (selectedVideoId != 0) ...[
                    Container(
                      color: const Color.fromARGB(175, 27, 27, 27),
                      height: 150*ScaleSize.textScaleFactor(context),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
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
                                      backgroundColor:
                                          Colors.black.withOpacity(0.01),
                                    ),
                                    child: const Icon(Icons.play_arrow,
                                        size: 35, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                    ]),),
                  ]),

              

                ],
              ),
            ),
          ],
        ),
      ),),
    );
  }

void _playVideo(BuildContext context, String videoId, String videoUrl) async {
  // Check if a previous video is still playing and dispose of it
  _videoPlayerController2?.dispose();
  _chewieController?.dispose();

  // Use asset video URL for Android or network URL for web
 String localVideoUrl = await loadVideo(videoId, videoUrl);

  // Create a new VideoPlayerController
  _videoPlayerController2 = VideoPlayerController.asset(localVideoUrl);

  // Show the video player dialog immediately
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
            aspectRatio: 16 / 9, // Default aspect ratio; will be updated
            child: FutureBuilder(
              future: _videoPlayerController2!.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Video is ready to play
                  _chewieController = ChewieController(
                    videoPlayerController: _videoPlayerController2!,
                    aspectRatio: _videoPlayerController2!.value.aspectRatio,
                    autoPlay: true,
                    looping: false,
                  );
                  return Chewie(controller: _chewieController!);
                } else {
                  // Show a loading spinner while the video is initializing
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    ),
  );
}

  Future<String> loadVideo(String videoId, String videoUrl) async {
    return videoUrl; // Fallback to the original network URL if not downloaded
  }
  @override
  void dispose() {
    _videoPlayerController2?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

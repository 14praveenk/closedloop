import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Page3NEW extends StatefulWidget {
  const Page3NEW({super.key});

    @override
  State<Page3NEW> createState() => _Page3NEWState();
}

class _Page3NEWState extends State<Page3NEW> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool videosDownloaded = false;

  final List<Map<String, String>> videoData = [
    {
      'id': 'video1',
      'title': 'LEADING A CARDIAC EMERGENCY',
      'thumbnail': 'assets/thumbnails/closedloop.jpg',
      'video': kIsWeb 
          ? 'assets/androidVideos/5clc.webm'
          : 'assets/androidVideos/5clc.webm'},
    {
      'id': 'video2',
      'title': 'DR ABC Assessment',
      'thumbnail': 'assets/thumbnails/breathingAssess.jpg',
      'video': kIsWeb
          ? 'assets/androidVideos/1assessBreathing.webm'
          : 'assets/androidVideos/1assessBreathing.webm'},
        {
      'id': 'video3',
      'title': 'DR ABC Assessment',
      'thumbnail': 'assets/thumbnails/drabc.jpg',
      'video': kIsWeb
          ? 'assets/androidVideos/2drabccardiac.webm'
          : 'assets/androidVideos/2drabccardiac.webm',
    },
        {
      'id': 'video4',
      'title': 'HOW TO CPR',
      'thumbnail': 'assets/thumbnails/cpr.jpg',
      'video': kIsWeb
          ? 'assets/androidVideos/3cpr.webm'
          : 'assets/androidVideos/3cpr.webm',   
    },
        {
      'id': 'video5',
      'title': 'HOW TO USE A DEFIB',
      'thumbnail': 'assets/thumbnails/defib.jpg',
      'video': kIsWeb 
          ? 'assets/androidVideos/4defib.webm'
          : 'assets/androidVideos/4defib.webm'},
           {
      'id': 'video6',
      'title': 'HOW TO DO RECOVERY POSITION',
      'thumbnail': 'assets/thumbnails/recovery.jpg',
      'video': kIsWeb 
          ? 'assets/androidVideos/6recovpos.webm'
          : 'assets/androidVideos/6recovpos.webm'},

  ];

  @override
  void initState() {
    super.initState();
  }




 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(175, 27, 27, 27),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _getMaxWidth(context)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Responsive Grid Layout for Videos
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
  // Check if a previous video is still playing and dispose of it
  _videoPlayerController?.dispose();
  _chewieController?.dispose();

  // Use asset video URL for Android or network URL for web
 String localVideoUrl = await loadVideo(videoId, videoUrl);

  // Create a new VideoPlayerController
  _videoPlayerController = VideoPlayerController.asset(localVideoUrl);

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
              future: _videoPlayerController!.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Video is ready to play
                  _chewieController = ChewieController(
                    videoPlayerController: _videoPlayerController!,
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
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
      // For Android, always use the asset video URL
      return videoUrl;
    }
  @override
  void dispose() {
    // Ensure that the controllers are not null before disposing
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

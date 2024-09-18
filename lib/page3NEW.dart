import 'package:flutter/material.dart';

class Page3NEW extends StatelessWidget {
  // Replace with your actual thumbnails and video data
  final List<Map<String, String>> videoData = [
    {
      'title': 'Video 1',
      'thumbnail': 'https://placehold.co/600x400/webp', // Replace with actual thumbnail URL
    },
    {
      'title': 'Video 2',
      'thumbnail': 'https://placehold.co/600x400/webp', // Replace with actual thumbnail URL
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 56, 56, 56),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 56, 56),
        title: Text(
          'Learn Closed-Loop',
          style: TextStyle(
            color: Colors.white,
                fontVariations: [FontVariation('wght', (400))],
                fontFamily: "NunitoSans"),
        ),
        leading: Icon(Icons.all_inclusive,color:Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: videoData.map((video) => _buildVideoCard(video)).toList(),
          ),
        ),
      ),
    );
  }

Widget _buildVideoCard(Map<String, String> video) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: const EdgeInsets.only(bottom: 16),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Image.network(
            video['thumbnail']!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
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
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle video playback action here
                },
                child: const Text('Watch Now'),
                style: ElevatedButton.styleFrom(
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}

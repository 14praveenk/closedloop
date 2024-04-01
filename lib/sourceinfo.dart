import 'package:flutter/material.dart';

class PlanetInfo {
  final int position;
  final String name;
  final String description;
  final List<String> images;
  final IconData icon;

  PlanetInfo(
    this.position, {
    required this.name,
    required this.description,
    required this.images,
    required this.icon,
  });
}

List<PlanetInfo> secondaryplanetInfo = [
PlanetInfo(1,
      name: 'Introduction',
      icon: Icons.question_mark,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
      PlanetInfo(2,
      name: 'Cardiac Arrest',
      icon: Icons.question_mark,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
      PlanetInfo(3,
      name: 'Surgical Procedures',
      icon: Icons.question_mark,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
];

List<PlanetInfo> planetInfo = [
  PlanetInfo(1,
      name: 'Allergy checks',
      icon: Icons.medication,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
  PlanetInfo(2,
      name: 'Asthma Confirm',
      icon: Icons.masks,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
  PlanetInfo(3,
      name: 'Item 3',
      icon: Icons.question_mark,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
  PlanetInfo(4,
      name: 'Item 4',
      icon: Icons.question_mark,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque placerat metus ipsum. Proin iaculis, diam nec dignissim egestas, eros lacus fermentum mi, id sodales massa quam non lectus. Quisque quis egestas ligula. Integer fringilla quis nulla nec vulputate. Aliquam vitae urna eget nisl varius viverra. Sed vel rutrum tellus. Praesent ac urna et ipsum euismod consectetur.",
      images: [
        'https://fakeimg.pl/600x400?text=VIDEO+1',
        'https://fakeimg.pl/600x400?text=VIDEO+2',
      ]),
];

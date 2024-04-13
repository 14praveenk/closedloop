import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = PageController(initialPage: 1);
  final _controller = NotchBottomBarController(index: 1);
  final List<Widget> pages = [Page1(), Page2(), Page3()];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: Row(
        children: [
          if (isLargeScreen) buildNavigationRail(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLargeScreen ? null : buildBottomBar(),
    );
  }

  Widget buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          kBottomRadius: 28.0,
          
          showLabel: false,
          bottomBarItems: const [
            BottomBarItem(
              inActiveItem: Icon(Icons.construction_rounded, color: Colors.blueGrey),
              activeItem: Icon(Icons.construction_rounded, color: Colors.blueAccent),
              itemLabel: 'Page 1',
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.home_rounded, color: Colors.blueGrey),
              activeItem: Icon(Icons.home_rounded, color: Colors.blueAccent),
              itemLabel: 'Home',
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.school_rounded, color: Colors.blueGrey),
              activeItem: Icon(Icons.school_rounded, color: Colors.blueAccent),
              itemLabel: 'Learn',
            ),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          kIconSize: 24.0,
        ),
      ],
    );
  }

  NavigationRail buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _controller.index,
      onDestinationSelected: (index) {
        setState(() {
          _controller.index = index;
          _pageController.jumpToPage(index);
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.construction_rounded),
          selectedIcon: Icon(Icons.construction_rounded, color: Colors.blueAccent),
          label: Text('tba'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.home_rounded),
          selectedIcon: Icon(Icons.home_rounded, color: Colors.blueAccent),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_rounded),
          selectedIcon: Icon(Icons.school_rounded, color: Colors.blueAccent),
          label: Text('Learn'),
        ),
      ],
    );
  }
}
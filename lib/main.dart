import 'dart:io'; // Import this for Platform
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'page1.dart';
import 'package:pwa_install/pwa_install.dart';

import 'page2NEWMOB.dart' // Stub implementation
    if (dart.library.io) 'page2NEWMOB.dart' // dart:io implementation
    if (dart.library.js_interop) 'page2NEWWEB.dart'; // package:web implementation

import 'page3NEWMOB.dart' // Stub implementation
    if (dart.library.io) 'page3NEWMOB.dart' // dart:io implementation
    if (dart.library.js_interop) 'page3NEWWEB.dart'; // package:web implementation
    
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

Future<void> main() async { PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const OnBoardingPage(), // Load the welcome page first
    );
  }
}

// Create a new OnBoardingPage class
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  // This function will navigate to the MainPage when the button is pressed
  void _onIntroEnd(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainPage()), // Replace with the MainPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/newBg.jpg"), // Background image
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6), // Adjust opacity as needed
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/newIcon.png', width: 250), // Display the icon
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                  backgroundColor: Color.fromRGBO(255, 224, 70, 1), // Button color
                ),
                child: Text(
                  'Revive someone today',
                  textScaleFactor: 1.25 * MediaQuery.of(context).textScaleFactor, // Adjust text scaling
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Avenir-Heavy',
                  ),
                ),
                onPressed: () => _onIntroEnd(context), // Navigate to MainPage
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// MainPage remains unchanged
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0; // To track the active page
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);
  final List<Widget> pages = [Page2NEW(), Page3NEW()];
  bool _promptShown = true; // Flag to track if the prompt has been shown

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/newBg.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),  // Adjust opacity as needed
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            if (isLargeScreen) buildNavigationRail(),
            Expanded(
              child: Container(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isLargeScreen ? null : buildBottomBar(),
      ),
    );
  }

  Widget buildBottomBar() {
    return CubertoBottomBar(
      barBackgroundColor: Color.fromARGB(175, 27, 27, 27),
      selectedTab: _currentPage,
      tabStyle: CubertoTabStyle.styleFadedBackground,
      inactiveIconColor: Colors.white,
      tabs: [
        TabData(
          iconData: Icons.video_call_outlined,
          title: 'Watch',
          tabColor: Color.fromARGB(255, 217, 221, 4),
        ),
        TabData(
          iconData: Icons.school_outlined,
          title: 'Learn',
          tabColor: Color.fromARGB(255, 217, 221, 4),
        ),
      ],
      onTabChangedListener: (position, title, color) {
        setState(() {
          _currentPage = position;
          _pageController.jumpToPage(position);
        });
      },
    );
  }

  NavigationRail buildNavigationRail() {
    return NavigationRail(
      backgroundColor: Colors.transparent,
      selectedIndex: _controller.index,
      useIndicator: true,
      indicatorColor: Color.fromARGB(175, 27, 27, 27),
      onDestinationSelected: (index) {
        setState(() {
          _controller.index = index;
          _pageController.jumpToPage(index);
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.video_call_outlined, color: Colors.white),
          selectedIcon: Icon(Icons.video_call_outlined, color: Color.fromARGB(255, 217, 221, 4)),
          label: Text(
            'Watch',
            style: TextStyle(
              fontFamily: "NunitoSans",
              fontVariations: [FontVariation('wght', 600)],
              color: Colors.white,
            ),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined, color: Colors.white),
          selectedIcon: Icon(Icons.school_outlined, color: Color.fromARGB(255, 217, 221, 4)),
          label: Text(
            'Learn',
            style: TextStyle(
              fontFamily: "NunitoSans",
              fontVariations: [FontVariation('wght', 600)],
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

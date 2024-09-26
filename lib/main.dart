import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2NEW.dart';
import 'page3NEW.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

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
  int _currentPage = 0; // To track the active page

  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);
  final List<Widget> pages = [Page2NEW(), Page3NEW()];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 56, 56, 56),
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
  });
}


  NavigationRail buildNavigationRail() {
    return NavigationRail(
      backgroundColor: Color.fromARGB(175, 27, 27, 27),
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
          label: Text('Watch',style: TextStyle(fontFamily:"NunitoSans",fontVariations: [FontVariation('wght', 600)], color:Colors.white),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined, color: Colors.white),
          selectedIcon: Icon(Icons.school_outlined, color: Color.fromARGB(255, 217, 221, 4)),
          label: Text('Learn',style: TextStyle(fontFamily:"NunitoSans", fontVariations: [FontVariation('wght', 600)],color:Colors.white)),
        ),
      ],
    );
  }
}
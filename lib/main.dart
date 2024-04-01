import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final List<Widget> bottomBarPages = [Page1(), Page2(), Page3()];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),

      bottomNavigationBar: Row(mainAxisAlignment:MainAxisAlignment.center,children:[AnimatedNotchBottomBar(
  notchBottomBarController: _controller,
  kBottomRadius: 28.0,
bottomBarWidth:600,
showLabel:false,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(
                    Icons.construction_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.construction_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 1',
          ),
              
                    BottomBarItem(
            inActiveItem: Icon(
                    Icons.home_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 2',
          ),
                BottomBarItem(
            inActiveItem: Icon(
                    Icons.school_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.school_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Page 3',
          ),
        ],
        onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )]
      ),
    );
  }
}

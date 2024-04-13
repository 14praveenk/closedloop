import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'sourceinfo.dart';
import 'details.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Closed Loop',
            style: GoogleFonts.nunitoSans(textStyle: TextStyle())),
        leading: Icon(Icons.all_inclusive),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 600,
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    50 -
                    MediaQuery.of(context).padding.top -
                    kBottomNavigationBarHeight,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          style: (GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 0.1,
                                  color: Color.fromRGBO(0, 0, 0, 0.44)))),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Search',
                            hintStyle: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 0.1,
                                    color: Color.fromRGBO(0, 0, 0, 0.44))),
                            prefixIcon: Icon(Icons.search),
                            fillColor: Color.fromARGB(255, 243, 243, 243),
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Card(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'What is closed loop communication?',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(fontSize: 20))),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(Size.fromWidth(150)),
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            EdgeInsets.fromLTRB(
                                                10, 10, 10, 10))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text('Learn more',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle:
                                                      TextStyle(fontSize: 20))),
                                          Icon(Icons.arrow_forward_ios)
                                        ]),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  DetailsPage(
                                                      planetInfo:
                                                          secondaryplanetInfo[
                                                              0])));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Text(
                            'Practice today',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(fontSize: 30)),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(40, 15, 40, 0),
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 40, // Spacing between columns
                            mainAxisSpacing: 40, // Spacing between rows
                          ),
                          itemCount: planetInfo.length,
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                textStyle: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        DetailsPage(
                                            planetInfo: planetInfo[index]),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    planetInfo[index].iconimage,
                                    height: 50,
                                    width: 50,
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 0)),
                                  Text(planetInfo[index].name,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 1)))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

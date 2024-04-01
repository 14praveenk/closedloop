import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'sourceinfo.dart';
import 'details.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn',
          style: GoogleFonts.nunitoSans(textStyle: TextStyle()),
        ),
        leading: Icon(Icons.all_inclusive),
        actions: [
          Icon(Icons.person),
          SizedBox(width: 16), // For spacing
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 20,
                          letterSpacing: 0.1,
                          color: Color.fromRGBO(0, 0, 0, 0.44))),
                  prefixIcon: Icon(Icons.search),
                  fillColor: Color.fromARGB(255, 243, 243, 243),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 243, 243, 243),
                      )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                  child: Text(
                    'Most popular',
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w300)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 300,
                    width: (MediaQuery.of(context).size.width / 2) - 32,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 149, 50),
                            Color.fromARGB(255, 203, 44, 44),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextButton(
                        onPressed: () {
                                                Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DetailsPage(
                                          planetInfo: secondaryplanetInfo[1])
                              )
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Column(children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(child:Text('Cardiac Arrest',textScaler: TextScaler.linear(2*ScaleSize.textScaleFactor(context)),
                                              style: GoogleFonts.nunitoSans(
                                                textStyle: const TextStyle(
                                                    height: 1.4,
                                                    
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              )),),
                                        ]),
                                    Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,children:[Text(
                                      '3 videos',textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white)),
                                    )]),
                                  ])),
                              Spacer(),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 15, 15),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Text("Not started",textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                                style: GoogleFonts.nunitoSans(
                                                    textStyle: TextStyle(
                                                        
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white)))),
                                        Icon(Icons.play_circle_outline,
                                            size: 20, color: Colors.white)
                                      ]))
                            ])),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    height: 300,
                    width: (MediaQuery.of(context).size.width / 2) - 32,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 137, 46, 255),
                            Color.fromARGB(255, 28, 83, 167),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextButton(
                        onPressed: () {
                                                Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DetailsPage(
                                          planetInfo: secondaryplanetInfo[2])
                              )
                          );
                        },
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(child:Text('Surgical Procedures',textScaler: TextScaler.linear(2*ScaleSize.textScaleFactor(context)),
                                              style: GoogleFonts.nunitoSans(
                                                textStyle: const TextStyle(
                                                    height: 1.4,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              )),)
                                        ]),
                                    Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,children:[Text(
                                      '3 videos',textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white)),
                                    )]),
                                      ])),
                              Spacer(),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 15, 15),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Text("2 left",textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                                                style: GoogleFonts.nunitoSans(
                                                    textStyle: TextStyle(
                                                        
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white)))),
                                        Icon(Icons.play_circle_outline,
                                            size: 20, color: Colors.white)
                                      ]))
                            ])),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 0, 10),
                  child: Text(
                    'Completed',
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w300)),
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                child: Column(children: [
                  Container(
                      height: 60,
                      width: double.infinity,
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Fundamentals",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                          fontSize: 25,
                                        )))),
                                Spacer(),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.check))
                              ])))),
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                child: Column(children: [
                  Container(
                      height: 60,
                      width: double.infinity,
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Key Terms",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                          fontSize: 25,
                                        )))),
                                Spacer(),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.check))
                              ])))),
                ])),
          ],
        ),
      ),
    );
  }
}

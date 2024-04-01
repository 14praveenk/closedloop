import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
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

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Closed Loop', style:GoogleFonts.nunitoSans(textStyle:TextStyle())),
        leading: Icon(Icons.all_inclusive),
        actions: [
          Icon(Icons.person),
          SizedBox(width: 16), // For spacing
        ],
      ),
      body: OrientationBuilder( builder: (context, orientation) {return SingleChildScrollView(
        child: Column(
          children: [Container(height: orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.1 : (MediaQuery.of(context).size.height < 500 ? MediaQuery.of(context).size.height * 0.25: MediaQuery.of(context).size.height * 0.1),child:
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
            ),),Container(height: orientation == Orientation.portrait? MediaQuery.of(context).size.height < 700 ? MediaQuery.of(context).size.height * 0.25 : MediaQuery.of(context).size.height * 0.2 : (MediaQuery.of(context).size.height < 900 ? MediaQuery.of(context).size.height * 0.3: MediaQuery.of(context).size.height * 0.2),child:
            Padding(
              padding: const EdgeInsets.fromLTRB(16,0,0,10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Align(alignment:Alignment.centerLeft, child:Text('What is closed loop communication?',textScaler: TextScaler.linear(1.5*ScaleSize.textScaleFactor(context)), style: GoogleFonts.nunitoSans(textStyle:TextStyle())),
                      ),Spacer(),
                      Align(alignment:Alignment.bottomRight, child:ElevatedButton(style:ButtonStyle(padding:MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(10, 10, 10, 10))),
                        child: Text('Learn more',textScaler: TextScaler.linear(1*ScaleSize.textScaleFactor(context)),style:GoogleFonts.nunitoSans(textStyle:TextStyle())),
                        onPressed: () {                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DetailsPage(
                                          planetInfo: secondaryplanetInfo[0])
                              )
                          );},
                      ),),
                    ],
                  ),
                ),
              ),
            ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16,0,0,0),
                  child: Text('Practice today',textScaler: TextScaler.linear(1.5*ScaleSize.textScaleFactor(context)), style: GoogleFonts.nunitoSans(textStyle:TextStyle()),),
                ),
              ],
            ),
            Container(
              margin:EdgeInsets.fromLTRB(20,15,20,0),
              height: orientation == Orientation.portrait ? MediaQuery.of(context).size.height < 800 ? 0.35*MediaQuery.of(context).size.height : 0.47*MediaQuery.of(context).size.height : MediaQuery.of(context).size.height < 700 ? 0.5*MediaQuery.of(context).size.height : 0.4*MediaQuery.of(context).size.height, // Adjust height as needed
              child: Swiper(
                itemWidth: MediaQuery.of(context).size.width < 1200 ? 0.7*MediaQuery.of(context).size.width : 0.4*MediaQuery.of(context).size.width ,
                  itemHeight: orientation == Orientation.portrait ? MediaQuery.of(context).size.height < 800 ? 0.35*MediaQuery.of(context).size.height : 0.4*MediaQuery.of(context).size.height : MediaQuery.of(context).size.height < 700 ? 0.58*MediaQuery.of(context).size.height : 0.4*MediaQuery.of(context).size.height,
                itemCount: planetInfo.length,
                layout: MediaQuery.of(context).size.height < 800 ? SwiperLayout.DEFAULT:SwiperLayout.STACK ,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        activeColor: Colors.blue,
                        activeSize: 12,
                        space: 4)),
                itemBuilder: (context, index) {
                                        return InkWell(
                                          hoverColor: Colors.transparent,
                        onTap: () {
                          
                          // Navigator
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DetailsPage(
                                          planetInfo: planetInfo[index])
                              )
                          );
                        },
                        child: 
                                CustomCard(
                                  name: planetInfo[index].name,
                                                      icon: planetInfo[index].icon,
                                ),
                        
                      );
                },
              ),
            ),
          ],
        ),
      );},),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String name;
  final IconData icon;
  const CustomCard({Key? key, required this.name, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(34.0),
        child: Column(children:[Align(alignment:Alignment.topRight,child:Icon(icon, size: 40)),Spacer(),Align(alignment:Alignment.bottomLeft,child:Column(
          mainAxisAlignment: MainAxisAlignment.end, // Adjust alignment here
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,textScaler: TextScaler.linear(2*ScaleSize.textScaleFactor(context)),
              style: GoogleFonts.nunitoSans(textStyle:TextStyle(
                  fontWeight: FontWeight.w600,
                  ),),
              textAlign: TextAlign.left,
            ),
            Text(
              "[Insert description]",textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
              style: GoogleFonts.nunitoSans(textStyle:TextStyle(
                  fontWeight: FontWeight.w400,
                  
                  ),),
              textAlign: TextAlign.left,
            ),
          
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Learn More",textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  style: GoogleFonts.nunitoSans(textStyle:TextStyle(
                      fontWeight: FontWeight.w600,
                      
                      ),),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                )
              ],
            ),
          ],),
        ),]),
      ),
    );
  }
}


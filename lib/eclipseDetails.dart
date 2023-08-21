import 'package:eclipsear/const/app_bar.dart';
import 'package:eclipsear/models/appBackground.dart';
import 'package:eclipsear/models/countDownTimer.dart';
import 'package:eclipsear/models/eclipseTypeIcon.dart';
import 'package:flutter/material.dart';

import 'const/app_colors.dart';

class EclipseDetailsPage extends StatefulWidget {
  EclipseDetailsPage(
      {Key? key,
      required this.title,
      required this.eclipseData,
      required this.eclipseType})
      : super(key: key);

  final String title;
  final dynamic eclipseData;
  final String eclipseType;

  @override
  _EclipseDetailsPageState createState() => _EclipseDetailsPageState();
}

class _EclipseDetailsPageState extends State<EclipseDetailsPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // titleSpacing: 5,
          elevation: 0,
          backgroundColor: AppColors.darkbrown,
          title: CustomAppBar(
            pageTitle: 'Eclipse',
            viewLogo: false,
          ),
        ),
        body: homePageContent());
  }

  Widget homePageContent() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // child: SingleChildScrollView(
        child: AppBGSet(
          topWidget: eclipsePanelWidget(),
          middleWidget: Center(),
          pageContent: Center(),
        ));
  }

  Widget eclipsePanelWidget() {
    print(widget.eclipseData['eclipseMg']);

    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.02),
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  EclipseIcon().getimageFromVar(widget.eclipseData['Type'],
                      widget.eclipseData['eclipseMg'], widget.eclipseType),
                  width: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eclipseData['Type'],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CountdownTimer(
                            targetDate: DateTime.parse(
                                widget.eclipseData['date'] +
                                    " " +
                                    widget.eclipseData['maxEclipse'])),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'start',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          widget.eclipseData['Time'],
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Max',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          widget.eclipseData['maxEclipse'],
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'End',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          widget.eclipseData['peEnd'],
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}

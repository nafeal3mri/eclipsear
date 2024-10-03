import 'package:auto_size_text/auto_size_text.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:eclipsear/const/app_bar.dart';
import 'package:eclipsear/eclipseDetailsMap.dart';
import 'package:eclipsear/models/appBackground.dart';
import 'package:eclipsear/models/countDownTimer.dart';
import 'package:eclipsear/models/dateFormatter.dart';
import 'package:eclipsear/models/eclipseTypeIcon.dart';
import 'package:eclipsear/models/timeDiff.dart';
import 'package:eclipsear/models/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

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

class _EclipseDetailsPageState extends State<EclipseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late VideoPlayerController _vidcontroller;
  late String formatteddate;
  Widget viewPage = Container();
  void initState() {
    super.initState();
    _controller = TabController(
        vsync: this, length: widget.eclipseType == "solar" ? 2 : 1);
    formatteddate = DateFormatter().getdatetimgformatted(
            false, widget.eclipseData['date'],
            dateFormat: "yyyyMMdd") +
        "_B";
    _vidcontroller = VideoPlayerController.networkUrl(Uri.parse(
        'https://in-the-sky.org/news/eclipses/solar_$formatteddate.mp4'))
      ..initialize().then((_) => setState(() {}));
    _controller.addListener(() {
      if (_controller.index == 1) {
        _vidcontroller.play();
        // print(_vidcontroller.value.isInitialized);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // titleSpacing: 5,
          elevation: 0,
          backgroundColor: AppColors.darkbrown,
          title: CustomAppBar(
            pageTitle: widget.title,
            viewLogo: false,
            viewLocation: true,
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
          bodyHasPadding: true,
          topWidget: eclipsePanelWidget(),
          middleWidget:
              widget.eclipseType == "solar" ? buttonTabs() : buttonLunar(),
          pageContent:
              widget.eclipseType == "solar" ? tabsContent() : contentLunar(),
        ));
  }

  Widget eclipsePanelWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.002),
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     AutoSizeText(
                    //       AppLocalizations.of(context)!.eclipseTypes + ": ",
                    //       minFontSize: 18,
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     AutoSizeText(
                    //       this.widget.eclipseType,
                    //       minFontSize: 15,
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          AppLocalizations.of(context)!.visibility + ": ",
                          minFontSize: 18,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          AppLocalizations.of(context)!.ecVisibility(
                              widget.eclipseData['Type'] + "Short"),
                          minFontSize: 15,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          AppLocalizations.of(context)!.date + ": ",
                          minFontSize: 18,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          DateFormatter().getdatetimgformatted(
                              false, widget.eclipseData['date'],
                              dateFormat: "d MMMM yyyy"),
                          minFontSize: 15,
                        ),
                      ],
                    ),
                    widget.eclipseType == "solar"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                AppLocalizations.of(context)!.magnitude + ": ",
                                minFontSize: 18,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              AutoSizeText(
                                widget.eclipseData['eclipseMg'].toString() ??
                                    "-",
                                minFontSize: 15,
                              ),
                            ],
                          )
                        : Container(),
                    widget.eclipseType == "solar" &&
                            widget.eclipseData['Type'] != "notVisible"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                AppLocalizations.of(context)!.coverage + ": ",
                                minFontSize: 18,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              AutoSizeText(
                                widget.eclipseData['coverage'].toString() ==
                                        "1.000"
                                    ? "100%"
                                    : (widget.eclipseData['coverage'] * 100)
                                            .toStringAsFixed(2) +
                                        "%",
                                minFontSize: 15,
                              ),
                            ],
                          )
                        : Container(),
                    widget.eclipseData['Type'] != "notVisible"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                AppLocalizations.of(context)!.douration + ": ",
                                minFontSize: 18,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TimeDifferenceCalculator(
                                  time1Str: widget.eclipseData['date'] +
                                      " " +
                                      widget.eclipseData['Time'],
                                  time2Str: widget.eclipseData['date'] +
                                      " " +
                                      widget.eclipseData['peEnd']),
                            ],
                          )
                        : Container(),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      EclipseIcon().getimageFromVar(widget.eclipseData['Type'],
                          widget.eclipseData['eclipseMg'], widget.eclipseType),
                      width: 80,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.001),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountdownTimer(
                              targetDate: DateTime.parse(
                                  widget.eclipseData['date'] +
                                      " " +
                                      widget.eclipseData['maxEclipse'])),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.start,
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
                          AppLocalizations.of(context)!.max,
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
                          AppLocalizations.of(context)!.end,
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

  Widget buttonTabs() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.8,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: ButtonsTabBar(
                // physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                splashColor: AppColors.darkbrown_press,
                backgroundColor: AppColors.darkbrown,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.only(right: 25, left: 25),
                radius: 50,
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    // icon: Icon(Icons.directions_car),
                    text: AppLocalizations.of(context)!.eclipsePath,
                  ),
                  Tab(
                    // icon: Icon(Icons.directions_car),
                    text: AppLocalizations.of(context)!.eclipseSimulation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonLunar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.8,
      child: DefaultTabController(
        length: 1,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: ButtonsTabBar(
                controller: _controller,
                splashColor: AppColors.darkbrown_press,
                backgroundColor: AppColors.darkbrown,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.only(right: 25, left: 25),
                radius: 50,
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.eclipsePath,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabsContent() {
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: <Widget>[
          EclipseMapDetails(
            eclipseDate: widget.eclipseData['date'],
            eclipseType: widget.eclipseType,
          ),
          viewEclipseVideos(),
        ],
      ),
    );
  }

  Widget contentLunar() {
    String fdate = DateFormatter().getdatetimgformatted(
            false, widget.eclipseData['date'],
            dateFormat: "yyyyMMdd");
    try {
      return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: <Widget>[
          Image.network("https://in-the-sky.org/news/eclipses/lunar_$fdate.png")
        ],
      ),
    );
    } catch (e) {
      return Text("can't view eclipse path");
    }
    
  }

  Widget viewEclipseVideos() {
    return Column(
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: _vidcontroller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_vidcontroller),
                ControlsOverlay(controller: _vidcontroller),
                VideoProgressIndicator(
                  _vidcontroller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                      playedColor: AppColors.darkbrown_press),
                ),
              ],
            ),
          ),
        ),
        Text(
          "Cridit © Dominic Ford.",
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _vidcontroller.dispose();
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:eclipsear/const/app_bar.dart';
import 'package:eclipsear/models/appBackground.dart';
import 'package:eclipsear/models/countDownTimer.dart';
import 'package:eclipsear/models/eclipseTypeIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class _EclipseDetailsPageState extends State<EclipseDetailsPage>  with SingleTickerProviderStateMixin{
  late TabController _controller;

  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
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
          topWidget: eclipsePanelWidget(),
          middleWidget: buttonTabs(),
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
                  width: 80,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      AppLocalizations.of(context)!.eclipseType(
                          (widget.eclipseType) + widget.eclipseData['Type']),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      maxLines: 1,
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
                    top: MediaQuery.of(context).size.height * 0.03),
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
        height: MediaQuery.of(context).size.height*0.07,
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
                    text: AppLocalizations.of(context)!.solarEclipse,
                  ),
                  Tab(
                    // icon: Icon(Icons.directions_car),
                    text: AppLocalizations.of(context)!.lunarEclipse,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  Center(),
                  Center(),
                ],
              ),
            ),
          ],
        ),
      ),);
  }
}

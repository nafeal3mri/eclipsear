import 'package:auto_size_text/auto_size_text.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:eclipsear/const/app_bar.dart';
import 'package:eclipsear/const/app_colors.dart';
import 'package:eclipsear/eclipseDetails.dart';
import 'package:eclipsear/models/appBackground.dart';
import 'package:eclipsear/models/calc/eclipseCalc.dart';
import 'package:eclipsear/models/calc/lunareclipseCalc.dart';
import 'package:eclipsear/models/countDownTimer.dart';
import 'package:eclipsear/models/eclipseTypeIcon.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eclipsear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  DateTime now = DateTime.now();
  int _yearActive = DateTime.now().year;
  final calcEclipse = CalculateSolarEclipse();
  final calcLunEclipse = CalculateLunarEclipse();
  var eclipseFinalData = [];
  var _tabdata;
  var luneclipseFinalData = [];
  var selectdEclipseData;
  var selectdLunEclipseData;
  var eclipseImg = 'assets/eclipses/se1.png';
  var leclipseImg = 'assets/eclipses/penleclipse.png';
  bool _isloading = false;
  late var _selectedYearData;
  late TabController _controller;
  var _annual_list;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    _controller.addListener(() {
      databyyear("", 2023);
      setState(() {});
    });
    // iosnotificationpermission();
    // getEclipseData();
    // getLunarEclipseData();
    getEclipseData();
    _selectedYearData = databyyear("", _yearActive);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // titleSpacing: 5,
          elevation: 0,
          backgroundColor: AppColors.darkbrown,
          title: CustomAppBar(
            pageTitle: 'EclipseAR',
            viewLogo: true,
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
          topWidget: topPanelCounterWidget(),
          middleWidget: middlePanelCounterWidget(),
          pageContent: pageContent(),
        ));
  }

  Widget topPanelCounterWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
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
                backgroundColor: AppColors.lightbrown,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(color: Colors.white),
                contentPadding: EdgeInsets.only(right: 25, left: 25),
                radius: 50,
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    // icon: Icon(Icons.directions_car),
                    text: "Solar Eclipse",
                  ),
                  Tab(
                    // icon: Icon(Icons.directions_car),
                    text: "Lunar Eclipse",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  eclipsePanelWidget("solar"),
                  eclipsePanelWidget("lunar"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget middlePanelCounterWidget() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.04,
        width: double.infinity,
        margin: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.1,
            left: MediaQuery.of(context).size.width * 0.1),
        child: ListView.builder(
            itemCount: generateButtonsYears(limit: 10).length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              int yearbtn = generateButtonsYears()[index];
              return Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _yearActive = yearbtn;
                        _selectedYearData = databyyear("", _yearActive);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      // foregroundColor: AppColors.darkbrown_press,
                      backgroundColor: _yearActive == yearbtn
                          ? AppColors.darkbrown
                          : AppColors.lightbrown,
                      side: BorderSide(
                        color: _yearActive == yearbtn
                            ? AppColors.lightbrown
                            : AppColors
                                .darkbrown, // Set the border color to white
                        width: 1.0, // Set the border width
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the border radius as needed
                      ),
                    ),
                    child: Text(yearbtn.toString()),
                  ));
            }));
  }

  Widget pageContent() {
    // var listingec = databyyear("", _yearActive);
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView.builder(
          itemCount: _annual_list.length,
          itemBuilder: (BuildContext context, int index) {
            // print([0]);
            var listingec = _annual_list[index];
            return Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.1,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.01,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: selectdEclipseData['date'] == listingec['date'] ||
                          selectdLunEclipseData['date'] == listingec['date']
                      ? AppColors.lightbrown15
                      : AppColors.lightbrown10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        EclipseIcon().getimageFromVar(
                            listingec['Type'],
                            listingec['eclipseMg'],
                            _controller.index == 0 ? "solar" : "lunar"),
                        width: 50,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            listingec['Type'],
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            maxLines: 1,
                            maxFontSize: 22,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            listingec['date'],
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listingec['Time'] != '--:--:--'
                            ? "Start: ${listingec['Time']}"
                            : '',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        "Max:  ${listingec['maxEclipse']}",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        listingec['peEnd'] != '--:--:--'
                            ? "End:   ${listingec['peEnd']}"
                            : '',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  generateButtonsYears({int limit = 10}) {
    int currentYear = now.year;
    // _yearActive = currentYear;
    int century;
    if (limit > 0) {
      century = limit;
    } else {
      century = (2100 - currentYear);
    }
    var yearlst = [];
    for (var yy = 0; yy <= century; yy++) {
      yearlst.add(currentYear + yy);
    }
    return yearlst;
  }

  Widget eclipsePanelWidget(eclipseType) {
    if (eclipseType == "solar") {
      _tabdata = selectdEclipseData;
    } else {
      _tabdata = selectdLunEclipseData;
    }
    // print(selectdEclipseData);

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
                  EclipseIcon().getimageFromVar(
                      _tabdata['Type'], _tabdata['eclipseMg'], eclipseType),
                  width: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      _tabdata['Type'],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      maxLines: 1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CountdownTimer(
                            targetDate: DateTime.parse(_tabdata['date'] +
                                " " +
                                _tabdata['maxEclipse'])),
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EclipseDetailsPage(
                                  title: "Eclipse",
                                  eclipseData: getSelectedEclipseArray(eclipseType),
                                  eclipseType: eclipseType
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    // foregroundColor: AppColors.darkbrown_press,
                    backgroundColor: AppColors.lightbrown,
                    side: BorderSide(
                      color:
                          AppColors.darkbrown, // Set the border color to white
                      width: 1.0, // Set the border width
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the border radius as needed
                    ),
                  ),
                  child: Text('View More'),
                )
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
                          _tabdata['Time'],
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
                          _tabdata['maxEclipse'],
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
                          _tabdata['peEnd'],
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }

  getSelectedEclipseArray(eclipseType){
    if (eclipseType == "solar") {
      return  selectdEclipseData;
    } else {
      return selectdLunEclipseData;
    }
  }

// Calcs

  getEclipseData() async {
    // prefs = await SharedPreferences.getInstance();
    // var latitude = prefs.getDouble('latitude');
    // var longitude = prefs.getDouble('longitude');
    // var altitude = prefs.getDouble('altitude');
    var latitude = 24.8038026;
    var longitude = 64.7521939;
    var altitude = 10;
    // if (ectype == "Solar") {
    var ecdata = calcEclipse.calculatefor(latitude, longitude, altitude);
    setState(() {
      eclipseFinalData = ecdata;
      selectedEclipse('isafter', DateTime.now().toString(), "Solar");
      // print(ecdata);
    });
    var ecldata = calcLunEclipse.calculatefor(latitude, longitude, altitude);
    luneclipseFinalData = ecldata;
    selectedEclipse('isafter', DateTime.now().toString(), "Lunar");
    // initWorkMngr();
  }

  selectedEclipse(datetype, selecteddate, ectype) async {
    if (ectype == "Solar") {
      setState(() {
        if (datetype == 'isafter') {
          selectdEclipseData = eclipseFinalData.firstWhere((eclipsedates) =>
              DateTime.parse(eclipsedates['DateTime'])
                  .isAfter(DateTime.parse(selecteddate)));
        } else if (datetype == 'issame') {
          selectdEclipseData = eclipseFinalData.firstWhere((eclipsedates) =>
              DateTime.parse(eclipsedates['DateTime'])
                  .isAtSameMomentAs(DateTime.parse(selecteddate)));
        }
        _isloading = false;
      });
    } else {
      setState(() {
        if (datetype == 'isafter') {
          selectdLunEclipseData = luneclipseFinalData.firstWhere(
              (eclipsedates) => DateTime.parse(eclipsedates['DateTime'])
                  .isAfter(DateTime.parse(selecteddate)));
        } else if (datetype == 'issame') {
          selectdLunEclipseData = luneclipseFinalData.firstWhere(
              (eclipsedates) => DateTime.parse(eclipsedates['DateTime'])
                  .isAtSameMomentAs(DateTime.parse(selecteddate)));
        }
        _isloading = false;
        // print(selectdEclipseData);
      });
    }
  }

  databyyear(datetype, year) {
    if (_controller.index == 0) {
      var listdata = eclipseFinalData.where((eclipsedates) =>
          DateTime.parse(eclipsedates['DateTime']).year == year);
      setState(() {
        _annual_list = listdata.toList();
      });
      return listdata.toList();
    } else {
      var listdata = luneclipseFinalData.where((eclipsedates) =>
          DateTime.parse(eclipsedates['DateTime']).year == year);
      setState(() {
        _annual_list = listdata.toList();
      });
      return [];
    }
  }
}

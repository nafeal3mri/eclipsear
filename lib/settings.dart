import 'dart:convert';

import 'package:eclipsear/aboutUs.dart';
import 'package:eclipsear/selectCity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'changeLocationMap.dart';
import 'const/app_bar.dart';
import 'const/app_colors.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  String _city = '';
  late SharedPreferences prefs;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        // titleSpacing: 5,
        elevation: 0,
        backgroundColor: AppColors.darkbrown,
        title: CustomAppBar(
          pageTitle: AppLocalizations.of(context)!.settings,
          viewLogo: false,
          viewLocation: false,
          showsettingsbtn: false,
        ),
        // backgroundColor: Color.fromARGB(255, 69, 56, 125),
        // title: Text(AppLocalizations.of(context)!.settings),
      ),
      backgroundColor: AppColors.lightbrown10,
      body: settingsBody(),
    );
  }

  Widget settingsBody() {
    return Column(
      children: [
        ListTile(
            onTap: () {
              showbottommodal();
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.location,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_city,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: iconByDirection()),
        Divider(),
        ListTile(
            onTap: () {
              changeLanguage();
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(
                Icons.language,
                color: Colors.white,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.language,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              languageText(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: iconByDirection()),
        Divider(),
        ListTile(
            onTap: () {
               Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUsPage()));
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.aboutus,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.learnaboutus,
              style: TextStyle(color: Colors.white),
            ),
            trailing: iconByDirection())
      ],
    );
  }

  Widget iconByDirection() {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 30.0)
        : Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0);
  }

  String languageText() {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? 'العربية'
        : 'English';
  }

  showbottommodal() {
    showModalBottomSheet(
        backgroundColor: AppColors.lightbrown15,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                title: new Text(
                  AppLocalizations.of(context)!.selectFromMap,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeLocationPage()));
                },
              ),
              // ListTile(
              //   leading: new Icon(Icons.flag, color: Colors.white),
              //   title: new Text(AppLocalizations.of(context)!.selectFromList,
              //       style: TextStyle(color: Colors.white)),
              //       onTap: () {
              //         Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => SelectCityPage()));
              //       },
              // ),
            ],
          );
        });
  }

  changeLanguage() {
    showModalBottomSheet(
        backgroundColor: AppColors.lightbrown15,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text("AR", style: TextStyle(color: Colors.white)),
                title: Text('العربية', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  setLanguage('ar');
                },
              ),
              ListTile(
                leading: Text(
                  "EN",
                  style: TextStyle(color: Colors.white),
                ),
                title: Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setLanguage('en');
                },
              ),
            ],
          );
        });
  }

  setLanguage(lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', lang).then((value) {
      // Locale.fromSubtags(languageCode: 'en');
      MyApp.of(context)!.setLocale(Locale.fromSubtags(
          languageCode: prefs.getString("language") ?? "en"));
    });
  }


  getLocation() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _city = prefs.getString('cityname') ?? '-';
    });
  }
}

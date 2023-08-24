import 'package:auto_size_text/auto_size_text.dart';
import 'package:eclipsear/settings.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.pageTitle,required this.viewLogo, required this.viewLocation, this.showsettingsbtn = true});
  final String pageTitle;
  final bool viewLogo;
  final bool viewLocation;
  final bool showsettingsbtn;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
    late SharedPreferences prefs;
      // cityname
  String _cityname = '-';
  @override
  void initState() {
    fetchCityName();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  fetchCityName() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _cityname = prefs.getString('cityname') ?? '-';
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02),
          width: MediaQuery.of(context).size.width ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            widget.viewLogo ? 
            Row(children: [
            Image.asset(
              'assets/icons/logo.png',
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            ],) : Container(),
            
            AutoSizeText(
              this.widget.pageTitle,
              style: TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.fade,
              maxFontSize: 20,
              softWrap: true,
              
              // stepGranularity: 2,
            ),
          ]),
          Row(
            children: [
              widget.viewLocation ?
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                child:
              Text(
                _cityname,
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              )):Container(),
              widget.showsettingsbtn?
              IconButton(
                icon: Icon(
                  LineIcons.cog,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                },
              ):Container(),
            ],
          )
        ],
      ),
    );
  }
}

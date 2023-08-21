import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:geocoding/geocoding.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.pageTitle,required this.viewLogo});
  final String pageTitle;
  final bool viewLogo;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  String _cityname = 'dejiocefjcioefjcoicjeoicrejo';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02),
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
            Text(
              this.widget.pageTitle,
              style: TextStyle(color: Colors.white),
            ),
          ]),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                child:
              Text(
                _cityname,
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              )),
              IconButton(
                icon: Icon(
                  LineIcons.cog,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eclipsear/models/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'const/app_bar.dart';
import 'const/app_colors.dart';
import 'main.dart';

class ChangeLocationPage extends StatefulWidget {
  ChangeLocationPage({Key? key}) : super(key: key);
  @override
  _ChangeLocationPageState createState() => _ChangeLocationPageState();
}

class _ChangeLocationPageState extends State<ChangeLocationPage> {
  Completer<GoogleMapController> _controller = Completer();
  late SharedPreferences prefs;
  late String _mapStyle;
  Set<Marker> _markers = {};
  late AnimationController _ac;
  late Animation<Offset> _animation;
  PanelController _pc = new PanelController();
  String _selectdPos = '';
  late double _latitude;
  late double _longitude;
  late double _altitude;
  late BitmapDescriptor pinLocationIcon;
  String _country = '';
  String _city = '';
  @override
  void initState() {
    super.initState();
    // getuserLocation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 5,
        elevation: 0,
        backgroundColor: AppColors.darkbrown,
        title: CustomAppBar(
          pageTitle: AppLocalizations.of(context)!.location,
          viewLogo: false,
          viewLocation: false,
          showsettingsbtn: false,
        ),
        // backgroundColor: Color.fromARGB(255, 69, 56, 125),
        // title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: pageBody(),
    );
  }

  getuserLocation() async {
    BitmapDescriptor pinLocationIcon;
    prefs = await SharedPreferences.getInstance();
    var latitude = prefs.getDouble('latitude');
    var longitude = prefs.getDouble('longitude');

    CameraPosition _kLake =
        CameraPosition(target: LatLng(latitude!, longitude!), zoom: 4);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    sleep(Duration(seconds: 1));
    _markers.add(Marker(
      markerId: MarkerId(latitude.toString() + longitude.toString()),
      position: LatLng(latitude ?? 0, longitude ?? 0),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/mapdark.json').then((String mapStyle) {
      controller.setMapStyle(mapStyle);
    });
    getuserLocation();
    _controller.complete(controller);
  }

  pageBody() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 4.0,
              ),
              onTap: _handleTap,
            ),
          ),
          SlidingUpPanel(
            // color: AppColors.darkbrown,
            controller: _pc,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.21,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            panel: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   _selectdPos,
                  //   style: TextStyle(color: Colors.black, fontSize: 25),
                  // ),
                  AutoSizeText(
                    _country,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    maxFontSize: 23,
                    maxLines: 2,
                  ),
                  AutoSizeText(
                    _city,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    maxFontSize: 20,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        setNewUserLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        // foregroundColor: AppColors.darkbrown_press,
                        backgroundColor: AppColors.lightbrown,
                        side: BorderSide(
                          color: AppColors
                              .darkbrown, // Set the border color to white
                          width: 1.0, // Set the border width
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the border radius as needed
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.setLocation),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  setNewUserLocation() async {
    prefs.setDouble('latitude', _latitude);
    prefs.setDouble('longitude', _longitude);
    prefs.setDouble('altitude', _altitude);

//     getEclipseData
// getLunarEclipseData
    MyHomePage.of(context)?.getEclipseData();
    // Navigator.pop(context)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp(userlanguage: Locale(prefs.getString('language') ?? "en"))));
  }

  _handleTap(LatLng point) async {
    // print(point);
    // final getlatlngalt = GetLocationData();
    // print(getlatlngalt.locationCalc(point));

    _markers.clear();
    final GoogleMapController controller = await _controller.future;
    CameraPosition _kLake = CameraPosition(
        target: LatLng(point.latitude, point.longitude), zoom: 9);
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    _pc.animatePanelToPosition(1);
    // final coordinates = new Coordinates(point.latitude, point.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    // print(
    //     "${first.countryName},${first.locality},${first.subLocality},${first.addressLine}");
    final geocoder =
        await GeoCoding().getCityFromLatlng(point.latitude, point.longitude);
    prefs.setString('cityname', geocoder['city']);
    setState(() {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(12, 12)),
              'assets/icons/pin.png')
          .then((onValue) {
        pinLocationIcon = onValue;
        _markers.add(Marker(
          markerId: MarkerId(onValue.toString()),
          position: LatLng(point.latitude, point.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ));
      });

      _latitude = point.latitude;
      _longitude = point.longitude;
      _altitude = point.longitude;
      _selectdPos = point.latitude.toStringAsFixed(4) +
          ',' +
          point.longitude.toStringAsFixed(4);

      _country = geocoder['country'];
      _city = geocoder['city'];
    });
  }
}

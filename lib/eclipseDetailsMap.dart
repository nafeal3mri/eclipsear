import 'dart:async';
import 'dart:io';

import 'package:eclipsear/eclipsePath/mapPath.dart';
import 'package:eclipsear/models/calc/solarEclipse/ecPath.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EclipseMapDetails extends StatefulWidget {
  EclipseMapDetails(
      {Key? key, required this.eclipseDate, required this.eclipseType})
      : super(key: key);

  final String eclipseDate;
  final String eclipseType;
  @override
  _EclipseMapDetailsState createState() => _EclipseMapDetailsState();
}

class _EclipseMapDetailsState extends State<EclipseMapDetails>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  Completer<GoogleMapController> _mapController = Completer();

  List<LatLng> mainpath = [];
  List<LatLng> polylinePoints = [LatLng(0, 0)];
  List<LatLng> polylinePoints1 = [LatLng(0, 0)];
  List<LatLng> polylinePoints2 = [LatLng(0, 0)];
  List<LatLng> polylinePoints3 = [LatLng(0, 0)];
  List<LatLng> polylinePoints4 = [LatLng(0, 0)];
  List<LatLng> polylinePoints5 = [LatLng(0, 0)];
  List<LatLng> polylinePoints6 = [LatLng(0, 0)];

  void initState() {
    _controller = TabController(vsync: this, length: 2);
    _fetchPolylineData();
    setState(() {});
  }

  Future<void> _fetchPolylineData() async {
    var fetchedData = await SEmapPath()
        .requestToPahts(widget.eclipseDate, ecType: widget.eclipseType);

    setState(() {
      mainpath = fetchedData.length > 0 ? fetchedData[0]['main'] : [];
      polylinePoints = fetchedData[1]['line1'];
      polylinePoints1 = fetchedData[2]['line2'];
      polylinePoints2 = fetchedData[3]['line3'];
      polylinePoints3 = fetchedData[4]['line4'];
      polylinePoints4 = fetchedData[5]['line5'];
      polylinePoints5 = fetchedData[6]['line6'];
    });
    final GoogleMapController mapcontroller = await _mapController.future;
    CameraPosition _kLake = CameraPosition(target: polylinePoints[0], zoom: 1);
    mapcontroller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/lightmap.json').then((String mapStyle) {
      controller.setMapStyle(mapStyle);
    });
    _mapController.complete(controller);
  }

  Widget contentMap() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2.0,
        ),

        //  markers: Set.from(pathPoints.map((point) {
        //   return Marker(markerId: MarkerId(point.toString()), position: point);
        // })),
        polylines: {
          Polyline(
              polylineId: PolylineId('mainpath'),
              color: Color.fromARGB(205, 104, 23, 17),
              points: mainpath,
              width: 1)
        },
        polygons: {
          Polygon(
              polygonId: PolygonId('pathmain'),
              fillColor: Color.fromARGB(146, 104, 23, 17),
              points: polylinePoints,
              strokeWidth: 0),
          Polygon(
              polygonId: PolygonId('path1'),
              fillColor: Color.fromARGB(50, 255, 229, 101),
              points: polylinePoints1,
              strokeWidth: 0),
          Polygon(
              polygonId: PolygonId('path2'),
              fillColor: Color.fromARGB(75, 255, 229, 101),
              points: polylinePoints2,
              strokeWidth: 0),
          Polygon(
              polygonId: PolygonId('path3'),
              fillColor: Color.fromARGB(100, 186, 162, 41),
              points: polylinePoints3,
              strokeWidth: 0),
          Polygon(
              polygonId: PolygonId('path4'),
              fillColor: Color.fromARGB(78, 202, 70, 60),
              points: polylinePoints4,
              strokeWidth: 0),
          Polygon(
              polygonId: PolygonId('path5'),
              fillColor: Color.fromARGB(78, 202, 70, 60),
              points: polylinePoints5,
              strokeWidth: 0),
          Polygon(
              polygonId: PolygonId('path6'),
              fillColor: Color.fromARGB(78, 202, 70, 60),
              points: polylinePoints6,
              strokeWidth: 0),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return contentMap();
  }
}

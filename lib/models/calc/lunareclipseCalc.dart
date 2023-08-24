import 'dart:math' as Math;
import 'package:flutter/material.dart';

import 'lunarEclipse/timeperiod.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateLunarEclipse {
  // Location location = new Location();
  // SharedPreferences prefs;
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // LocationData _locationData;
  var month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<double> p1 = List.filled(1000,1000);
  List<double> u1 = List.filled(1000,1000);
  List<double> u2 = List.filled(1000,1000);
  List<double> mid = List.filled(1000,1000);
  List<double> u3 = List.filled(1000,1000);
  List<double> u4 = List.filled(1000,1000);
  List<double> p4 = List.filled(1000,1000);
  var currenttimeperiod = "";
  List<double> loadedtimeperiods = List.filled(1000,1000);
  List<double> obsvconst = List.filled(1000,1000);
  List<Map<String, dynamic>> eclipseDates = [];

  // Populate the circumstances array
// entry condition - circumstances[1] must contain the correct value
  populatecircumstances(elements, circumstances) {
    var t, ra, dec, h;
    int index;
    index = obsvconst[4].toInt();
    t = circumstances[1];
    ra = elements[18 + index] * t + elements[17 + index];
    ra = ra * t + elements[16 + index];
    dec = elements[21 + index] * t + elements[20 + index];
    dec = dec * t + elements[19 + index];
    dec = dec * Math.pi / 180.0;
    circumstances[3] = dec;
    h = 15.0 *
            (elements[6 + index] +
                (t - elements[2 + index] / 3600.0) * 1.00273791) -
        ra;
    h = h * Math.pi / 180.0 - obsvconst[1];
    circumstances[2] = h;
    circumstances[4] = Math.asin(Math.sin(obsvconst[0]) * Math.sin(dec) +
        Math.cos(obsvconst[0]) * Math.cos(dec) * Math.cos(h));
    circumstances[4] -= Math.asin(
        Math.sin(elements[7 + index] * Math.pi / 180.0) *
            Math.cos(circumstances[4]));
    if (circumstances[4] * 180.0 / Math.pi < elements[8 + index] - 0.5667) {
      circumstances[5] = 2.0;
    } else if (circumstances[4] < 0.0) {
      circumstances[4] = 0.0;
      circumstances[5] = 0.0;
    } else {
      circumstances[5] = 0.0;
    }
  }

// Populate the p1, u1, u2, mid, u3, u4 and p4 arrays
  getall(elements) {
    var pattern, index;

    index = obsvconst[4].toInt();
    p1[1] = elements[index + 9];
    populatecircumstances(elements, p1);
    mid[1] = elements[index + 12];
    populatecircumstances(elements, mid);
    p4[1] = elements[index + 15];
    populatecircumstances(elements, p4);
    if (elements[index + 5] < 3) {
      u1[1] = elements[index + 10];
      populatecircumstances(elements, u1);
      u4[1] = elements[index + 14];
      populatecircumstances(elements, u4);
      if (elements[index + 5] < 2) {
        u2[1] = elements[index + 11];
        u3[1] = elements[index + 13];
        populatecircumstances(elements, u2);
        populatecircumstances(elements, u3);
      } else {
        u2[5] = 1;
        u3[5] = 1;
      }
    } else {
      u1[5] = 1;
      u2[5] = 1;
      u3[5] = 1;
      u4[5] = 1;
    }
    if ((p1[5] != 0) &&
        (u1[5] != 0) &&
        (u2[5] != 0) &&
        (mid[5] != 0) &&
        (u3[5] != 0) &&
        (u4[5] != 0) &&
        (p4[5] != 0)) {
      mid[5] = 1;
    }
  }

// Read the data that's in the form, and populate the obsvconst array
  readform(latitude, longitude, altitude) {
    var latabsolute = (latitude).abs();
    var latdegrees = (latabsolute).floor();
    var latminutesNotTruncated = (latabsolute - latdegrees) * 60;
    var latminutes = (latminutesNotTruncated).floor();
    var latseconds = ((latminutesNotTruncated - latminutes) * 60).floor();

    var lngabsolute = (longitude).abs();
    var lngdegrees = (lngabsolute).floor();
    var lngminutesNotTruncated = (lngabsolute - lngdegrees) * 60;
    var lngminutes = (lngminutesNotTruncated).floor();
    var lngseconds = ((lngminutesNotTruncated - lngminutes) * 60).floor();
    var latx;
    var lonx;
    // print(latabsolute.toString()+','+lngabsolute.toString());
    int timezoneh =
        int.parse((DateTime.now().timeZoneOffset).toString().split(':')[0]);
    int timezonem =
        int.parse((DateTime.now().timeZoneOffset).toString().split(':')[1]);
    int timezonloc = -1;
    if (timezoneh < 0) {
      timezonloc = 1;
    }

    if (latitude > 0) {
      latx = 1; //North
    } else {
      latx = -1; //South
    }
    if (longitude > 0) {
      lonx = -1; // East
    } else {
      lonx = 1; // West
    }
    // print(latdegrees.toString()+','+latminutes.toString()+','
    // +latseconds.toString()+','+lngdegrees.toString()+','
    // +lngminutes.toString()+','+lngseconds.toString()+','
    // +latx.toString()+','+lonx.toString());
    var tmp;

    var latd = latdegrees;
    var latm = latminutes;
    var lats = latseconds;
    var lond = lngdegrees;
    var lonm = lngminutes;
    var lons = lngseconds;
    var alt = 304;
    // var latx = 1; //N
    // var lonx = -1; //E

    var tzh = (timezoneh).abs();
    var tzm = timezonem;
    var tzx = timezonloc;

    // Get the latitude
    obsvconst[0] = latd + latm / 60.0 + lats / 3600.0;
    obsvconst[0] = obsvconst[0] * latx;
    obsvconst[0] = obsvconst[0] * Math.pi / 180.0;

    // Get the longitude
    obsvconst[1] = lond + lonm / 60.0 + lons / 3600.0;
    obsvconst[1] = obsvconst[1] * lonx;
    obsvconst[1] = obsvconst[1] * Math.pi / 180.0;

    // Get the altitude
    obsvconst[2] = alt.toDouble();

    // Get the time zone
    obsvconst[3] = tzm.toDouble();
    obsvconst[3] = tzh + obsvconst[3] / 60.0;
    obsvconst[3] = tzx * obsvconst[3];

    obsvconst[4] = 0;
    obsvconst[5] = 4;
  }

// Get the local date of an event
  getdate(elements, circumstances) {
    var t, ans, jd, a, b, c, d, e;
    int index;
    index = obsvconst[4].toInt();
    // Calculate the JD for noon (TDT) the day before the day that contains T0
    jd = (elements[index] - (elements[1 + index] / 24.0)).floor();
    // Calculate the local time (ie the offset in hours since midnight TDT on the day containing T0).
    t = circumstances[1] +
        elements[1 + index] -
        obsvconst[3] -
        (elements[2 + index] - 30.0) / 3600.0;
    if (t < 0.0) {
      jd--;
    }
    if (t >= 24.0) {
      jd++;
    }
    if (jd >= 2299160.0) {
      a = ((jd - 1867216.25) / 36524.25).floor();
      a = jd + 1 + a - (a / 4).floor();
    } else {
      a = jd;
    }
    b = a + 1525.0;
    c = ((b - 122.1) / 365.25).floor();
    d = (365.25 * c).floor();
    e = ((b - d) / 30.6001).floor();
    d = b - d - (30.6001 * e).floor();
    if (e < 13.5) {
      e = e - 1;
    } else {
      e = e - 13;
    }
    if (e > 2.5) {
      ans = (c - 4716).toString() + "-";
    } else {
      ans = (c - 4715).toString() + "-";
    }
    if (e < 10) {
      ans = ans.toString() + "0";
    }
    ans += e.toString() + "-";
    if (d < 10) {
      ans = ans.toString() + "0";
    }
    ans = ans + d.toInt().toString();
    return ans;
  }

// Get the local time of an event
  gettime(elements, circumstances) {
    var t, ans, html, ital;
    int index;
    ans = "";
    index = obsvconst[4].toInt();
    t = circumstances[1] +
        elements[1 + index] -
        obsvconst[3] -
        (elements[2 + index] - 30.0) / 3600.0;
    if (t < 0.0) {
      t = t + 24.0;
    }
    if (t >= 24.0) {
      t = t - 24.0;
    }
    if (t < 10.0) {
      ans = ans.toString() + "0";
    }
    ans = ans + (t.toInt()).toString() + ":";
    t = (t * 60.0) - 60.0 * (t).floor();
    if (t < 10.0) {
      ans = ans.toString() + "0";
    }
    ans = ans.toString() + (t).floor().toString();
    if (circumstances[5] == 2) {
      return ans + ":00";
    } else {
      return ans + ":00";
    }
  }

// Get the altitude
  getalt(circumstances) {
    var t, ans, html, ital;

    t = circumstances[4] * 180.0 / Math.pi;
    t = (t + 0.5).floor();
    if (t < 0.0) {
      ans = "-";
      t = -t;
    } else {
      ans = "+";
    }
    if (t < 10.0) {
      ans = ans + "0";
    }
    ans = ans.toString() + t.toString();
    if (circumstances[5] == 2) {
      return ans;
    } else {
      return ans;
    }
  }

// CALCULATE!
  List<Map<String, dynamic>> calculatefor(lat, lng, alt) {
    readform(lat, lng, alt);
    final timeper = TimePeriods();
    var el = timeper.le2001();
    var eDates, eStartTime, ecType, eMaximum, pEclipseEnd;

    for (double i = 1; i < el.length; i += 22) {
      if (el[5 + i.toInt()] <= obsvconst[5]) {
        obsvconst[4] = i;
        getall(el);
        // Is there an event...
        if (mid[5] != 1) {
          // Calendar Date
          // getdate(el,p1);
          // print(getdate(el, mid));
          eDates = getdate(el, mid);
          eStartTime = gettime(el, p1);
          // Maximum eclipse time
          eMaximum = gettime(el, mid);
          // Partial eclipse ends
          pEclipseEnd = gettime(el, p4);
          // Eclipse Type
          if (el[5 + i.toInt()] == 1) {
            //Total
            ecType = 'totalEclipse';
          } else if (el[5 + i.toInt()] == 2) {
            //Partial
            ecType = 'partialEclipse';
          } else {
            //Penumbral
            ecType = 'penumbralEclipse';
          }

          // Pen. Mag
          el[3 + i.toInt()];
          // Umbral Mag
          el[4 + i.toInt()];
          // P1
          gettime(el, p1);
          // P1 alt
          getalt(p1);
          if (u1[5] == 1) {
          } else {
            // U1
            gettime(el, u1);
            // U1 alt
            getalt(u1);
          }
          if (u2[5] == 1) {
          } else {
            // U2
            gettime(el, u2);
            // U2 alt
            getalt(u2);
          }
          // mid
          gettime(el, mid);
          // mid alt
          getalt(mid);
          if (u3[5] == 1) {
          } else {
            // u3
            gettime(el, u3);
            // u3 alt
            getalt(u3);
          }
          if (u4[5] == 1) {
          } else {
            // u4
            gettime(el, u4);
            // u4 alt
            getalt(u4);
          }
          // P4
          gettime(el, p4);
          // P4 alt
          getalt(p4);

          if (eDates != null) {
            eclipseDates += [
              {
                'date': eDates,
                'Time': eStartTime,
                'Type': ecType,
                'maxEclipse': eMaximum,
                'peEnd': pEclipseEnd,
                'DateTime': eDates + " " + eStartTime
              }
            ];
          }
        } else {
          eclipseDates += [
            {
              'date': getdate(el, mid),
              'Time': gettime(el, p1),
              'Type': 'notVisible',
              'maxEclipse': gettime(el, mid),
              'peEnd': gettime(el, p4),
              'DateTime': getdate(el, mid) + " " + gettime(el, mid)
            }
          ];
        }
      }
    }
    return eclipseDates;
  }
}

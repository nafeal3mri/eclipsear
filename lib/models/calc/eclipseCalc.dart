import 'dart:math' as Math;
import 'package:flutter/material.dart';

import 'solarEclipse/timeperiod.dart';
// import 'package:location/location.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CalculateSolarEclipse {
  // Location location = new Location();
  // SharedPreferences prefs;
  bool _serviceEnabled = false;
  // PermissionStatus _permissionGranted = false;
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
  List<double> c1 = List.filled(1000,1000);
  List<double> c2 = List.filled(1000,1000);
  List<double> mid = List.filled(1000,1000);
  List<double> c3 = List.filled(1000,1000);
  List<double> c4 = List.filled(1000,1000);
  var currenttimeperiod = "";
  List<double> loadedtimeperiods = List.filled(1000,1000);
  List<double> obsvconst = List.filled(1000,1000);
  List<Map<String, dynamic>> eclipseDates = [];
  // var eclipseStartTimes = [];
  // var eclipseStartTypes = [];
// Populate the circumstances array with the time-only dependent circumstances (x, y, d, m, ...)
  timedependent(List<double> elements, circumstances) {
    var type, t;
    double ans;
    int index;
    t = circumstances[1];
    index = obsvconst[6].toInt();
    // print(index);
    // Calculate x
    ans = elements[9 + index] * t + elements[8 + index];
    ans = ans * t + elements[7 + index];
    ans = ans * t + elements[6 + index];
    circumstances[2] = ans;
    // Calculate dx
    ans = 3.0 * elements[9 + index] * t + 2.0 * elements[8 + index];
    ans = ans * t + elements[7 + index];
    circumstances[10] = ans;
    // Calculate y
    ans = elements[13 + index] * t + elements[12 + index];
    ans = ans * t + elements[11 + index];
    ans = ans * t + elements[10 + index];
    circumstances[3] = ans;
    // Calculate dy
    ans = 3.0 * elements[13 + index] * t + 2.0 * elements[12 + index];
    ans = ans * t + elements[11 + index];
    circumstances[11] = ans;
    // Calculate d
    ans = elements[16 + index] * t + elements[15 + index];
    ans = ans * t + elements[14 + index];
    ans = ans * Math.pi / 180.0;
    circumstances[4] = ans;
    // sin d and cos d
    circumstances[5] = Math.sin(ans);
    circumstances[6] = Math.cos(ans);
    // Calculate dd
    ans = 2.0 * elements[16 + index] * t + elements[15 + index];
    ans = ans * Math.pi / 180.0;
    circumstances[12] = ans;
    // Calculate m
    ans = elements[19 + index] * t + elements[18 + index];
    ans = ans * t + elements[17 + index];
    if (ans >= 360.0) {
      ans = ans - 360.0;
    }
    ans = ans * Math.pi / 180.0;
    circumstances[7] = ans;
    // Calculate dm
    ans = 2.0 * elements[19 + index] * t + elements[18 + index];
    ans = ans * Math.pi / 180.0;
    circumstances[13] = ans;
    // Calculate l1 and dl1
    type = circumstances[0];
    if ((type == -2) || (type == 0) || (type == 2)) {
      ans = elements[22 + index] * t + elements[21 + index];
      ans = ans * t + elements[20 + index];
      circumstances[8] = ans;
      circumstances[14] = 2.0 * elements[22 + index] * t + elements[21 + index];
    }
    // Calculate l2 and dl2
    if ((type == -1) || (type == 0) || (type == 1)) {
      ans = elements[25 + index] * t + elements[24 + index];
      ans = ans * t + elements[23 + index];
      circumstances[9] = ans;
      circumstances[15] = 2.0 * elements[25 + index] * t + elements[24 + index];
    }
    return circumstances;
  }

// Populate the circumstances array with the time and location dependent circumstances
  timelocdependent(List<double> elements, circumstances) {
    var ans, type;
    int index;
    timedependent(elements, circumstances);
    index = obsvconst[6].toInt();
    // Calculate h, sin h, cos h
    circumstances[16] =
        circumstances[7] - obsvconst[1] - (elements[index + 5] / 13713.44);
    circumstances[17] = Math.sin(circumstances[16]);
    circumstances[18] = Math.cos(circumstances[16]);
    // Calculate xi
    circumstances[19] = obsvconst[5] * circumstances[17];
    // Calculate eta
    circumstances[20] = obsvconst[4] * circumstances[6] -
        obsvconst[5] * circumstances[18] * circumstances[5];
    // Calculate zeta
    circumstances[21] = obsvconst[4] * circumstances[5] +
        obsvconst[5] * circumstances[18] * circumstances[6];
    // Calculate dxi
    circumstances[22] = circumstances[13] * obsvconst[5] * circumstances[18];
    // Calculate deta
    circumstances[23] =
        circumstances[13] * circumstances[19] * circumstances[5] -
            circumstances[21] * circumstances[12];
    // Calculate u
    circumstances[24] = circumstances[2] - circumstances[19];
    // Calculate v
    circumstances[25] = circumstances[3] - circumstances[20];
    // Calculate a
    circumstances[26] = circumstances[10] - circumstances[22];
    // Calculate b
    circumstances[27] = circumstances[11] - circumstances[23];
    // Calculate l1'
    type = circumstances[0];
    if ((type == -2) || (type == 0) || (type == 2)) {
      circumstances[28] =
          circumstances[8] - circumstances[21] * elements[26 + index];
    }
    // Calculate l2'
    if ((type == -1) || (type == 0) || (type == 1)) {
      circumstances[29] =
          circumstances[9] - circumstances[21] * elements[27 + index];
    }
    // Calculate n^2
    circumstances[30] = circumstances[26] * circumstances[26] +
        circumstances[27] * circumstances[27];
    return circumstances;
  }

// Iterate on C1 or C4
  c1c4iterate(elements, circumstances) {
    var sign, iter, tmp, n;

    timelocdependent(elements, circumstances);
    if (circumstances[0] < 0) {
      sign = -1.0;
    } else {
      sign = 1.0;
    }
    tmp = 1.0;
    iter = 0;
    while (((tmp > 0.000001) || (tmp < -0.000001)) && (iter < 50)) {
      n = Math.sqrt(circumstances[30]);
      tmp = circumstances[26] * circumstances[25] -
          circumstances[24] * circumstances[27];
      tmp = tmp / n / circumstances[28];
      tmp = sign * Math.sqrt(1.0 - tmp * tmp) * circumstances[28] / n;
      tmp = (circumstances[24] * circumstances[26] +
                  circumstances[25] * circumstances[27]) /
              circumstances[30] -
          tmp;
      circumstances[1] = circumstances[1] - tmp;
      timelocdependent(elements, circumstances);
      iter++;
    }
    return circumstances;
  }

// Get C1 and C4 data
//   Entry conditions -
//   1. The mid array must be populated
//   2. The magnitude at mid eclipse must be > 0.0
  getc1c4(elements) {
    var tmp, n;

    n = Math.sqrt(mid[30]);
    tmp = mid[26] * mid[25] - mid[24] * mid[27];
    tmp = tmp / n / mid[28];
    tmp = Math.sqrt(1.0 - tmp * tmp) * mid[28] / n;
    c1[0] = -2;
    c4[0] = 2;
    c1[1] = mid[1] - tmp;
    c4[1] = mid[1] + tmp;
    c1c4iterate(elements, c1);
    c1c4iterate(elements, c4);
  }

// Iterate on C2 or C3
  c2c3iterate(elements, circumstances) {
    var sign, iter, tmp, n;

    timelocdependent(elements, circumstances);
    if (circumstances[0] < 0) {
      sign = -1.0;
    } else {
      sign = 1.0;
    }
    if (mid[29] < 0.0) {
      sign = -sign;
    }
    tmp = 1.0;
    iter = 0;
    while (((tmp > 0.000001) || (tmp < -0.000001)) && (iter < 50)) {
      n = Math.sqrt(circumstances[30]);
      tmp = circumstances[26] * circumstances[25] -
          circumstances[24] * circumstances[27];
      tmp = tmp / n / circumstances[29];
      tmp = sign * Math.sqrt(1.0 - tmp * tmp) * circumstances[29] / n;
      tmp = (circumstances[24] * circumstances[26] +
                  circumstances[25] * circumstances[27]) /
              circumstances[30] -
          tmp;
      circumstances[1] = circumstances[1] - tmp;
      timelocdependent(elements, circumstances);
      iter++;
    }
    return circumstances;
  }

// Get C2 and C3 data
//   Entry conditions -
//   1. The mid array must be populated
//   2. There must be either a total or annular eclipse at the location!
  getc2c3(elements) {
    var tmp, n;

    n = Math.sqrt(mid[30]);
    tmp = mid[26] * mid[25] - mid[24] * mid[27];
    tmp = tmp / n / mid[29];
    tmp = Math.sqrt(1.0 - tmp * tmp) * mid[29] / n;
    c2[0] = -1;
    c3[0] = 1;
    if (mid[29] < 0.0) {
      c2[1] = mid[1] + tmp;
      c3[1] = mid[1] - tmp;
    } else {
      c2[1] = mid[1] - tmp;
      c3[1] = mid[1] + tmp;
    }
    c2c3iterate(elements, c2);
    c2c3iterate(elements, c3);
  }

// Get the observational circumstances
  observational(List<double> circumstances) {
    var contacttype, coslat, sinlat;

    // We are looking at an "external" contact UNLESS this is a total eclipse AND we are looking at
    // c2 or c3, in which case it is an INTERNAL contact! Note that if we are looking at mid eclipse,
    // then we may not have determined the type of eclipse (mid[39]) just yet!
    if (circumstances[0] == 0) {
      contacttype = 1.0;
    } else {
      if ((mid[39] == 3) &&
          ((circumstances[0] == -1) || (circumstances[0] == 1))) {
        contacttype = -1.0;
      } else {
        contacttype = 1.0;
      }
    }
    // Calculate p
    circumstances[31] = Math.atan2(
        contacttype * circumstances[24], contacttype * circumstances[25]);
    // Calculate alt
    sinlat = Math.sin(obsvconst[0]);
    coslat = Math.cos(obsvconst[0]);
    circumstances[32] = Math.asin(circumstances[5] * sinlat +
        circumstances[6] * coslat * circumstances[18]);
    // Calculate q
    circumstances[33] =
        Math.asin(coslat * circumstances[17] / Math.cos(circumstances[32]));
    if (circumstances[20] < 0.0) {
      circumstances[33] = Math.pi - circumstances[33];
    }
    // Calculate v
    circumstances[34] = circumstances[31] - circumstances[33];
    // Calculate azi
    circumstances[35] = Math.atan2(
        -1.0 * circumstances[17] * circumstances[6],
        circumstances[5] * coslat -
            circumstances[18] * sinlat * circumstances[6]);
    // Calculate visibility
    if (circumstances[32] > -0.00524) {
      circumstances[40] = 0;
    } else {
      circumstances[40] = 1;
    }
  }

// Get the observational circumstances for mid eclipse
  midobservational() {
    observational(mid);
    // Calculate m, magnitude and moon/sun
    mid[36] = Math.sqrt(mid[24] * mid[24] + mid[25] * mid[25]);
    mid[37] = (mid[28] - mid[36]) / (mid[28] + mid[29]);
    mid[38] = (mid[28] - mid[29]) / (mid[28] + mid[29]);
  }

// Calculate mid eclipse
  getmid(elements) {
    var iter, tmp;

    mid[0] = 0;
    mid[1] = 0.0;
    iter = 0;
    tmp = 1.0;
    timelocdependent(elements, mid);
    while (((tmp > 0.000001) || (tmp < -0.000001)) && (iter < 50)) {
      tmp = (mid[24] * mid[26] + mid[25] * mid[27]) / mid[30];
      // console.log(mid);
      mid[1] = mid[1] - tmp;
      iter++;
      timelocdependent(elements, mid);
    }
  }

// Calculate the time of sunrise or sunset
  getsunriset(elements, circumstances, riset) {
    var h0, diff, iter;

    diff = 1.0;
    iter = 0;
    while ((diff > 0.00001) || (diff < -0.00001)) {
      iter++;
      // if (iter == 4) return;
      h0 = Math.acos(
          (Math.sin(-0.00524) - Math.sin(obsvconst[0]) * circumstances[5]) /
              Math.cos(obsvconst[0]) /
              circumstances[6]);

      // print(obsvconst[0]);
      diff = (riset * h0 - circumstances[16]) / circumstances[13];
      while (diff >= 12.0) diff -= 24.0;
      while (diff <= -12.0) diff += 24.0;
      circumstances[1] += diff;
      timelocdependent(elements, circumstances);
    }
  }

// Calculate the time of sunrise
  getsunrise(elements, circumstances) {
    getsunriset(elements, circumstances, -1.0);
  }

// Calculate the time of sunset
  getsunset(elements, circumstances) {
    getsunriset(elements, circumstances, 1.0);
  }

// Copy a set of circumstances
  copycircumstances(circumstancesfrom, circumstancesto) {
    var i;

    for (i = 1; i < 41; i++) {
      circumstancesto[i] = circumstancesfrom[i];
    }
  }

// Populate the c1, c2, mid, c3 and c4 arrays
  getall(elements) {
    var pattern;

    getmid(elements);
    midobservational();
    if (mid[37] > 0.0) {
      getc1c4(elements);
      if ((mid[36] < mid[29]) || (mid[36] < -mid[29])) {
        getc2c3(elements);
        if (mid[29] < 0.0) {
          mid[39] = 3; // Total eclipse
        } else {
          mid[39] = 2; // Annular eclipse
        }
        observational(c1);
        observational(c2);
        observational(c3);
        observational(c4);
        c2[36] = 999.9;
        c3[36] = 999.9;
        // Calculate how much of the eclipse is above the horizon
        pattern = 0;
        if (c1[40] == 0) {
          pattern += 10000;
        }
        if (c2[40] == 0) {
          pattern += 1000;
        }
        if (mid[40] == 0) {
          pattern += 100;
        }
        if (c3[40] == 0) {
          pattern += 10;
        }
        if (c4[40] == 0) {
          pattern += 1;
        }
        // Now, time to make sure that all my observational[39] and observational[40] are OK
        if (pattern == 11110) {
          getsunset(elements, c4);
          observational(c4);
          c4[40] = 3;
        } else if (pattern == 11100) {
          getsunset(elements, c3);
          observational(c3);
          c3[40] = 3;
          copycircumstances(c3, c4);
        } else if (pattern == 11000) {
          c3[40] = 4;
          getsunset(elements, mid);
          midobservational();
          mid[40] = 3;
          copycircumstances(mid, c4);
        } else if (pattern == 10000) {
          mid[39] = 1;
          getsunset(elements, mid);
          midobservational();
          mid[40] = 3;
          copycircumstances(mid, c4);
        } else if (pattern == 1111) {
          getsunrise(elements, c1);
          observational(c1);
          c1[40] = 2;
        } else if (pattern == 111) {
          getsunrise(elements, c2);
          observational(c2);
          c2[40] = 2;
          copycircumstances(c2, c1);
        } else if (pattern == 11) {
          c2[40] = 4;
          getsunrise(elements, mid);
          midobservational();
          mid[40] = 2;
          copycircumstances(mid, c1);
        } else if (pattern == 1) {
          mid[39] = 1;
          getsunrise(elements, mid);
          midobservational();
          mid[40] = 2;
          copycircumstances(mid, c1);
        } else if (pattern == 0) {
          mid[39] = 0;
        }
        // There are other patterns, but those are the only ones we're covering!
      } else {
        mid[39] = 1; // Partial eclipse
        pattern = 0;
        observational(c1);
        observational(c4);
        if (c1[40] == 0) {
          pattern += 100;
        }
        if (mid[40] == 0) {
          pattern += 10;
        }
        if (c4[40] == 0) {
          pattern += 1;
        }
        if (pattern == 110) {
          getsunset(elements, c4);
          observational(c4);
          c4[40] = 3;
        } else if (pattern == 100) {
          getsunset(elements, mid);
          midobservational();
          mid[40] = 3;
          copycircumstances(mid, c4);
        } else if (pattern == 11) {
          getsunrise(elements, c1);
          observational(c1);
          c1[40] = 2;
        } else if (pattern == 1) {
          getsunrise(elements, mid);
          midobservational();
          mid[40] = 2;
          copycircumstances(mid, c1);
        } else if (pattern == 0) {
          mid[39] = 0;
        }
        // There are other patterns, but those are the only ones we're covering!
      }
    } else {
      mid[39] = 0; // No eclipse

    }
    // Magnitude for total and annular eclipse is moon/sun ratio
    if ((mid[39] == 2) || (mid[39] == 3)) {
      mid[37] = mid[38];
    }
  }

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
    obsvconst[0] = (latd + latm / 60 + lats / 3600);
    obsvconst[0] = obsvconst[0] *= latx;
    obsvconst[0] = (obsvconst[0] * Math.pi / 180);

    // Get the longitude
    obsvconst[1] = (lond + lonm / 60.0 + lons / 3600.0);
    obsvconst[1] = obsvconst[1] * lonx;
    obsvconst[1] = (obsvconst[1] * Math.pi / 180.0);

    // Get the altitude
    obsvconst[2] = alt.toDouble();

    // Get the time zone
    obsvconst[3] = tzm.toDouble();
    obsvconst[3] = (tzh + obsvconst[3] / 60.0);
    obsvconst[3] = tzx * obsvconst[3];

    // Get the observer's geocentric position
    tmp = Math.atan(0.99664719 * Math.tan(obsvconst[0]));
    obsvconst[4] = (0.99664719 * Math.sin(tmp) +
        (obsvconst[2] / 6378140.0) * Math.sin(obsvconst[0]));
    obsvconst[5] =
        (Math.cos(tmp) + (obsvconst[2] / 6378140.0 * Math.cos(obsvconst[0])));

    // The index of the selected eclipse...
    //obsvconst[6] = 28 * (parseInt(document.eclipseform.index.options[document.eclipseform.index.selectedIndex].value) + 65)
  }

  // Get the local date of an event
  getdate(List<double> elements, circumstances) {
    var t, jd, a, b, c, d, e;
    String ans;
    int index;
    index = obsvconst[6].toInt();
    // Calculate the JD for noon (TDT) the day before the day that contains T0
    jd = (elements[index] - (elements[1 + index] / 24.0)).floor();
    // Calculate the local time (ie the offset in hours since midnight TDT on the day containing T0).
    t = circumstances[1] +
        elements[1 + index] -
        obsvconst[3] -
        (elements[4 + index] - 0.5) / 3600.0;
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
    // print(e.toString()+'-'+d.toString());
    if (e < 10) {
      ans = ans.toString() + "0";
    }
    ans += e.toString() + "-";
    if (d < 10) {
      ans = "$ans" + "0";
    }
    ans = ans + d.toInt().toString();
    return ans;
  }

  gettime(List<double> elements, List<double> circumstances) {
    var ans;
    double t;
    int index;
    ans = "";
    index = obsvconst[6].toInt();
    t = (circumstances[1] +
        elements[1 + index].toInt() -
        obsvconst[3] -
        (elements[4 + index] - 0.5) / 3600.0);

    // print(t);

    if (t < 0.0) {
      t = t + 24.0;
    }
    if (t >= 24.0) {
      t = t - 24.0;
    }
    if (t < 10.0) {
      // ans = ans + "0";
      ans = "$ans" + "0";
    }
    var floorT = (t).floor();
    ans = "$ans" + (t).floor().toString() + ":";
    t = (t * 60.0) - 60.0 * (t).floor();
    if (t < 10.0) {
      ans = "$ans" + "0";
    }
    //Minutes
    ans = "$ans" + (t).floor().toString();
    if (circumstances[40] <= 1) {
      // not sunrise or sunset
      ans = "$ans:";
      t = (t * 60.0) - 60.0 * (t).floor();
      if (t < 10.0) {
        ans = ans + "0";
      }
      //Seconds
      ans = "$ans" + (t).floor().toString();
    }
    if (circumstances[40] == 1) {
      // html = document.createElement("font");
      // html.setAttribute("color","#808080");
      // ital = document.createElement("i");
      // ital.appendChild(document.createTextNode(ans));
      // html.appendChild(ital);
      return ans;
    } else if (circumstances[40] == 2) {
      // return ans + "(r)";
      return ans + ":00";
    } else if (circumstances[40] == 3) {
      // return ans + "(s)";
      return ans + ":00";
    } else {
      return ans;
    }
  }

// Get the altitude
  getalt(circumstances) {
    var t, ans;

    if (circumstances[40] == 2) {
      // return "0(r)";
      return "0";
    }
    if (circumstances[40] == 3) {
      // return "0(s)";
      return "0";
    }
    if ((circumstances[32] < 0.0) && (circumstances[32] >= -0.00524)) {
      // Crude correction for refraction (and for consistency's sake)
      t = 0.0;
    } else {
      t = circumstances[32] * 180.0 / Math.pi;
    }
    if (t < 0.0) {
      ans = "-";
      t = -t;
    } else {
      ans = "";
    }
    t = (t + 0.5).floor();
    if (t < 10.0) {
      ans = ans + "0";
    }
    ans = "$ans" + t.toString();
    if (circumstances[40] == 1) {
      // html = document.createElement("font");
      // html.setAttribute("color","#808080");
      // ital = document.createElement("i");
      // ital.appendChild(document.createTextNode(ans));
      // html.appendChild(ital);
      return ans;
    } else {
      return ans;
    }
  }

// Get the azimuth
  getazi(circumstances) {
    var t, ans;

    ans = "";
    t = circumstances[35] * 180.0 / Math.pi;
    if (t < 0.0) {
      t = t + 360.0;
    }
    if (t >= 360.0) {
      t = t - 360.0;
    }
    t = (t + 0.5).floor();
    if (t < 100.0) {
      ans = ans + "0";
    }
    if (t < 10.0) {
      ans = ans + "0";
    }
    ans = "$ans $t";
    if (circumstances[40] == 1) {
      // html = document.createElement("font");
      // html.setAttribute("color","#808080");
      // ital = document.createElement("i");
      // ital.appendChild(document.createTextNode(ans));
      // html.appendChild(ital);
      return ans;
    } else {
      return ans;
    }
  }

//
// Get the duration in mm:ss.s format
//
// Adapted from code written by Stephen McCann - 27/04/2001
  getduration() {
    var tmp, ans;

    if (c3[40] == 4) {
      tmp = mid[1] - c2[1];
    } else if (c2[40] == 4) {
      tmp = c3[1] - mid[1];
    } else {
      tmp = c3[1] - c2[1];
    }
    if (tmp < 0.0) {
      tmp = tmp + 24.0;
    } else if (tmp >= 24.0) {
      tmp = tmp - 24.0;
    }
    tmp = (tmp * 60.0) - 60.0 * (tmp).floor() + 0.05 / 60.0;
    ans = ((tmp).floor()).toString() + "m";
    tmp = (tmp * 60.0) - 60.0 * (tmp).floor();
    if (tmp < 10.0) {
      ans = ans + "0";
    }
    ans += ((tmp).floor()).toString() + "s";
    return ans;
  }

// Get the magnitude
  getmagnitude() {
    var a;

    a = (1000.0 * mid[37] + 0.5).floor() / 1000.0;
    if (mid[40] == 1) {
      // html = document.createElement("font");
      // html.setAttribute("color","#808080");
      // ital = document.createElement("i");
      // ital.appendChild(document.createTextNode(a));
      // html.appendChild(ital);
      return a;
    }
    // if (mid[40] == 2) {
    //   // a = "$a (r)";
    //   a = "$a";
    // }
    // if (mid[40] == 3) {
    //   // a = "$a (s)";
    //   a = "$a";
    // }
    return a;
  }

// Get the coverage
  getcoverage() {
    var a, b, c;

    if (mid[37] <= 0.0) {
      a = "0.0";
    } else if (mid[37] >= 1.0) {
      a = "1.000";
    } else {
      if (mid[39] == 2) {
        c = mid[38] * mid[38];
      } else {
        c = Math.acos(
            (mid[28] * mid[28] + mid[29] * mid[29] - 2.0 * mid[36] * mid[36]) /
                (mid[28] * mid[28] - mid[29] * mid[29]));
        b = Math.acos((mid[28] * mid[29] + mid[36] * mid[36]) /
            mid[36] /
            (mid[28] + mid[29]));
        a = Math.pi - b - c;
        c = ((mid[38] * mid[38] * a + b) - mid[38] * Math.sin(c)) / Math.pi;
      }
      a = (1000.0 * c + 0.5).floor() / 1000.0;
    }
    if (mid[40] == 1) {
      // html = document.createElement("font");
      // html.setAttribute("color","#808080");
      // ital = document.createElement("i");
      // ital.appendChild(document.createTextNode(a));
      // html.appendChild(ital);
      return a;
    }
    if (mid[40] == 2) {
      // a = "$a (r)";
      a = "$a";
    }
    if (mid[40] == 3) {
      // a = "$a (s)";
      a = "$a";
    }
    return a;
  }

// CALCULATE!

  List<Map<String, dynamic>> calculatefor(lat, lng, alt) {
    final timeper = TimePeriods();
    var el = timeper.se2001();
    var eDates, eStartTime, ecType, eMaximum, pEclipseEnd;

    readform(lat, lng, alt);
    for (double i = 0; i < el.length; i += 28) {
      obsvconst[6] = i;
      getall(el);
      // print(el);
      // print(obsvconst[6]);

      // Is there an event...
      if (mid[39] > 0) {
        // print(getdate(el, mid)+" - " + gettime(el, c1));
        // print(mid);
        //  eclipseDates
        eDates = getdate(el, mid);
        eStartTime = gettime(el, c1);
        // Maximum eclipse time
        eMaximum = gettime(el, mid);
        // Partial eclipse ends
        pEclipseEnd = gettime(el, c4);
        // getdate(el, mid);
        if (mid[39] == 1) {
          //P
          ecType = 'partialEclipse';
          //Partial Eclipse
        } else if (mid[39] == 2) {
          //A
          ecType = 'annularEclipse';
          //annular Eclipse
        } else {
          //T
          ecType = 'totalEclipse';
          //Total Eclipse
        }
        // Partial eclipse start
        if (c1[40] == 4) {
          // -
        } else {
          // Partial eclipse start time
          gettime(el, c1);
          // Partial eclipse alt
          getalt(c1);
        }
        // Central eclipse time
        if ((mid[39] > 1) && (c2[40] != 4)) {
          gettime(el, c2);
        } else {
          // -
        }

        // Maximum eclipse alt
        getalt(mid);
        // Maximum eclipse azi
        getazi(mid);
        // Central eclipse ends
        if ((mid[39] > 1) && (c3[40] != 4)) {
          gettime(el, c3);
        } else {
          // -
        }
        // Partial eclipse ends
        if (c4[40] == 4) {
          // -
        } else {
          // ... sun alt
          getalt(c4);
        }
        // Eclipse magnitude
        getmagnitude();
        // Coverage
        getcoverage();

        // Central duration
        if (mid[39] > 1) {
          getduration();
        } else {
          //-
        }
        if (eDates != null) {
          eclipseDates += [
            {
              'date': eDates,
              'Time': eStartTime,
              'Type': ecType,
              'maxEclipse': eMaximum,
              'peEnd': pEclipseEnd,
              'eclipseMg': getmagnitude(),
              'DateTime': eDates + " " + eMaximum
            }
          ];
        }
      } else {
        // print(getdate(el, mid));
        // print(gettime(el, mid));
        if (eDates != null) {
          eclipseDates += [
            {
              'date': getdate(el, mid),
              'Time': '--:--:--',
              'Type': 'notVisible',
              'maxEclipse': gettime(el, mid),
              'peEnd': '--:--:--',
              'eclipseMg': getmagnitude(),
              'DateTime': getdate(el, mid) + " " + gettime(el, mid)
            }
          ];
        }
      }
    } //EndFor
    // print(eclipseDates);
    return eclipseDates;
  }
}

import 'package:csc_picker/csc_picker.dart';
import 'package:eclipsear/models/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'const/app_bar.dart';
import 'const/app_colors.dart';

class SelectCityPage extends StatefulWidget {
  SelectCityPage({Key? key}) : super(key: key);

  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  /// Variables to store country state city data in onChanged method.
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  bool isloading = false;
  bool isSelected = false;
  late double _latitude;
  late double _longitude;
  late double _altitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 5,
        elevation: 0,
        backgroundColor: AppColors.darkbrown,
        title: CustomAppBar(
          pageTitle: AppLocalizations.of(context)!.selectFromList,
          viewLogo: false,
          viewLocation: false,
          showsettingsbtn: false,
        ),
        // backgroundColor: Color.fromARGB(255, 69, 56, 125),
        // title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: Container(
          color: AppColors.darkbrown,
            padding: EdgeInsets.only(left: 10,right: 10,top: 30),
            height: MediaQuery.of(context).size.height *1,
            child: Column(
              children: [
                ///Adding CSC Picker Widget in app
                CSCPicker(
                  ///Enable disable state dropdown [OPTIONAL PARAMETER]
                  showStates: true,

                  /// Enable disable city drop down [OPTIONAL PARAMETER]
                  showCities: true,

                  ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                  ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///selected item style [OPTIONAL PARAMETER]
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                  dropdownHeadingStyle: TextStyle(
                      color: AppColors.darkbrown,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

                  ///DropdownDialog Item style [OPTIONAL PARAMETER]
                  dropdownItemStyle: TextStyle(
                    color: AppColors.darkbrown,
                    fontSize: 14,
                  ),

                  ///Dialog box radius [OPTIONAL PARAMETER]
                  dropdownDialogRadius: 10.0,

                  ///Search bar radius [OPTIONAL PARAMETER]
                  searchBarRadius: 10.0,

                  ///triggers once country selected in dropdown
                  onCountryChanged: (value) {
                    setState(() {
                      ///store value in country variable
                      countryValue = value;
                    });
                  },

                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      stateValue = value ?? '';
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      ///store value in city variable
                      cityValue = value ?? "";
                      isloading = true;
                      isSelected = true;
                      searchCity();
                    });
                  },
                ),

                ///print newly selected country state and city in Text Widget
                // TextButton(
                //     onPressed: () {
                //       setState(() {
                //         address = "$cityValue, $stateValue, $countryValue";
                //       });
                //     },
                //     child: Text("Print Data")),
                SizedBox(height: 20),
                isloading ? CircularProgressIndicator() : SizedBox(height: 20),
                isSelected
                    ? SizedBox(
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
                        // child: FlatButton(
                        //   shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(30.0),
                        //   ),
                        //   onPressed: () {
                        //     setNewUserLocation();
                        //   },
                        //   color: Color.fromARGB(255, 31, 160, 242),
                        //   child: Text(
                        //     AppLocalizations.of(context).translate('SetLoc'),
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 22.0,
                        //     ),
                        //   ),
                        // ),
                      )
                    : SizedBox(height: 20),
              ],
            )),
      ),
    );
  }

  setNewUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var address = await GeoCoding().getLatlngFromCity(countryValue,cityValue);
    _latitude = address['lat'];
    _longitude = address['lon'];
    _altitude = 0;
    prefs.setDouble('latitude', _latitude);
    prefs.setDouble('longitude', _longitude);
    prefs.setDouble('altitude', _altitude);
    
    Navigator.pop(context);
  }

  searchCity() async {
    setState(() {
      isloading = false;
    });
  }
}

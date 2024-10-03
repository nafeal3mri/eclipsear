import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'const/app_bar.dart';
import 'const/app_colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.darkbrown,
        title: CustomAppBar(
          pageTitle: AppLocalizations.of(context)!.aboutus,
          viewLogo: false,
          viewLocation: false,
          showsettingsbtn: false,
        ),
      ),
      backgroundColor: AppColors.lightbrown10,
      body: Container(
        margin: EdgeInsets.all(20),
        child: Text(AppLocalizations.of(context)!.aboutuscontent),
      ),
    );
  }
}

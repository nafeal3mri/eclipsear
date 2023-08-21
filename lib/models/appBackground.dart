import 'package:eclipsear/const/app_colors.dart';
import 'package:flutter/material.dart';

class AppBGSet extends StatefulWidget {
  const AppBGSet({super.key, required this.topWidget, this.middleWidget = const Center(),required this.pageContent});
  final Widget topWidget;
  final Widget middleWidget;
  final Widget pageContent;
  @override
  State<AppBGSet> createState() => _AppBGSetState();
}

class _AppBGSetState extends State<AppBGSet> with TickerProviderStateMixin {
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
    var _mediaquery = MediaQuery.of(context).size;
    return Stack(children: <Widget>[
      Container(
        //background

        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          color: AppColors.darkbrown,
        ),
      ),
      Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.27),
        height: MediaQuery.of(context).size.height * 0.34,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0)),
          color: AppColors.lightbrown,
          // child: Text("data")
        ),
        child: Column(
          children: [
            Container(
              child: this.widget.middleWidget,
            )
            // formpanel(),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height * 0.26,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0)),
          color: AppColors.darkbrown,
        ),
        child: Column(
          children: [
            Container(
              child: this.widget.topWidget,
            )
            // formpanel(),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            this.widget.pageContent
          ],
        ),
      ),
    ]);
  }
}

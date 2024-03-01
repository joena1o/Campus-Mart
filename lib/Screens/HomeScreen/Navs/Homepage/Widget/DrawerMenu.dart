import 'package:campus_mart/Screens/AboutUsScreen/AboutUs.dart';
import 'package:campus_mart/Screens/AdAlertScreen/AdAlert.dart';
import 'package:campus_mart/Screens/AdAlertScreen/AdAlerts.dart';
import 'package:campus_mart/Screens/FeedbackScreen/Feedback.dart';
import 'package:campus_mart/Screens/HelpScreen/Help.dart';
import 'package:campus_mart/Screens/OptionScreen/OptionScreen.dart';
import 'package:campus_mart/Utils/savePrefs.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            height: kToolbarHeight * 2,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdAlerts()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.alertTriangleOutline),
                title: Text("Ad Alert"),
              )),

      GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) =>  const FeedbackPage()));
        },
        child:const ListTile(
            leading: Icon(EvaIcons.messageCircleOutline),
            title: Text("Feedback"),
          )),

          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Help()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.questionMark),
                title: Text("Help"),
              )),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AboutUs()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.infoOutline),
                title: Text("About Us"),
              )),

          const Divider(),
          GestureDetector(
              onTap: () {
                clearPrefs();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const OptionScreen()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.logInOutline),
                title: Text("Logout"),
              )),
        ],
      ),
    );
  }
}

import 'package:campus_mart/Provider/message_provider.dart';
import 'package:campus_mart/screens/about_us_screen/about_us.dart';
import 'package:campus_mart/screens/ad_alert_screen/ad_alerts.dart';
import 'package:campus_mart/screens/feed_back_screen/feed_back.dart';
import 'package:campus_mart/screens/my_ad_screen/my_ad_screen.dart';
import 'package:campus_mart/Utils/save_prefs.dart';
import 'package:campus_mart/screens/option_screen/option_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: kToolbarHeight * 2,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyAdScreen()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.activity),
                title: Text("My Ads"),
              )),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdAlerts()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.alertTriangleOutline),
                title: Text("Buzz Me"),
              )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FeedbackPage()));
              },
              child: const ListTile(
                leading: Icon(EvaIcons.messageCircleOutline),
                title: Text("Feedback"),
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
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          Consumer<MessageProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                  onTap: () {
                    OneSignal.logout();
                    provider.disconnectWebSocket();
                    clearPrefs();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const OptionScreen()));
                  },
                  child: const ListTile(
                    leading: Icon(EvaIcons.logInOutline),
                    title: Text("Logout"),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

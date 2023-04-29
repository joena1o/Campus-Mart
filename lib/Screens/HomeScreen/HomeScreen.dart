import 'package:campus_mart/Screens/AdScreen/AdScreen.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Homepage.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/DrawerMenu.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/NotificationPage/NotificationPage.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/ProfilePage/ProfilePage.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/WishList/WishList.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/BottomNav/BottomNav.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../MessageScreen/MessageScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentNav = 1;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  updateNav(val) {
    setState(() => currentNav = val);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      drawer: const Drawer(
        child: DrawerMenu(),
      ),
      appBar: currentNav != 4 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              margin: const EdgeInsets.only(left: 12),
              child:IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 25,
              )));
        }),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MessageScreen()));
              },
              icon: const Icon(
                Icons.messenger_outline,
                size: 22,
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ):null,
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: size.width * .037),
        child: (currentNav == 1)
            ? const HomepageNav()
            : ((currentNav == 2)
                ? const WishListt()
                : ((currentNav == 3)
                    ? const NotificationPage()
                    : const ProfilePage())),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        elevation: 0,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AdScreen()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: BottomNav(
          index: currentNav,
          callback: updateNav,
        ),
      ),
    );
  }
}

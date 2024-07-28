import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/NotificationServiceClass.dart';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/message_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Screens/CategoryScreen/CategoryScreen.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Homepage.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/DrawerMenu.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/NotificationPage/NotificationPage.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/ProfilePage/ProfilePage.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/WishList/WishList.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/BottomNav/BottomNav.dart';
import 'package:campus_mart/Screens/MessageScreen/MessageScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

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
  void initState(){
    super.initState();

    NotificationService.requestPermissions();

    //Set Up for user Provider
    Provider.of<UserProvider>(context, listen: false).setUserDetails(
      Provider.of<AuthProvider>(context, listen: false).userModel
    );

    //Subscribe User
    UserModel? user = context.read<UserProvider>().userDetails;
    OneSignal.shared.setExternalUserId(user!.id.toString());

    OneSignal.shared.sendTag("campus", user.campus); // Campus Tag
    OneSignal.shared.sendTag("state", user.state); // State Tag

    Provider.of<UserProvider>(context, listen: false).loadDetails();
    Provider.of<MessageProvider>(context, listen: false).initProvider(user!);

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
          currentNav != 3 ?  IconButton(
              onPressed: () {
                context.read<ProductProvider>().resetItems();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CategoryScreen(index: -1,)));
              },
              icon: const Icon(
                Icons.search_sharp,
                size: 28,
                color: primary,
              )):Container(),
        ],
      ):null,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: (currentNav == 1)
            ? const HomepageNav()
            : ((currentNav == 2)
                ? const WishListt()
                : ((currentNav == 3)
                    ? const NotificationPage()
                    : const ProfilePage())),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: BottomNav(
          index: currentNav,
          callback: updateNav,
        ),
      ),
      floatingActionButton: Consumer<MessageProvider>(
        builder: (context, provider, child) {
            return badges.Badge(
                    position: badges.BadgePosition.topStart(start: 43),
                    badgeContent: Text("${provider.chats.where((element) => element.seen == false && element.receiverId == context.read<UserProvider>().userDetails?.id ).length}"),
                    showBadge: provider.chats.where((element) => element.seen == false && element.receiverId == context.read<UserProvider>().userDetails?.id).isNotEmpty,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: primary,
                      onPressed: (){
                        // showMessageError("Feature not ready yet", context);
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> const MessageScreen()));
                    },
                    child: const FaIcon(FontAwesomeIcons.message, color: Colors.white,),
                  ),
                );
            },
      ),
    );
  }


}

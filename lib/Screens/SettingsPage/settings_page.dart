import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Screens/ChangePassword/change_password.dart';
import 'package:campus_mart/Screens/EditProfileScreen/edit_profile_screen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool? isEnabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status();
  }

  Future<void> status() async{
    final onesignal = await OneSignal.shared.getDeviceState();
    setState(()=> isEnabled = onesignal!.pushDisabled);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontSize: 17),),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20,),

            const Text("Theme", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
            const Divider(),

            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const EditProfileScreen()));
                },
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      const Text(
                        "Dark Mode",
                        style: TextStyle(fontSize: 15),
                      ),

                      Consumer<ThemeProvider>(
                        builder: (context, provider, child) {
                          return Switch(
                            value: provider.isDark,
                            onChanged: (value) {
                              setState(() {
                                provider.switchTheme(value);
                              });
                            },
                            activeColor: primary,
                            activeTrackColor: Colors.orangeAccent,
                          );
                        },
                      )

                    ],
                  ),
                )),

            const SizedBox(height: 40,),

            const Text("Account", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
            const Divider(),

            const SizedBox(height: 10,),

            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const EditProfileScreen()));
                },
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child:  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                       Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 15),
                      ),

                      const Icon(Icons.keyboard_arrow_right_rounded, size: 30,)

                    ],
                  ),
                )),

            const SizedBox(height: 10,),

              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage()));
                  },
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child:  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                         Text(
                          "Change Account Password",
                          style: TextStyle(fontSize: 15),
                        ),

                        Icon(Icons.keyboard_arrow_right_rounded, size: 30,)

                      ],
                    ),
                  )),


            const SizedBox(height: 40,),

            const Text("Notification", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
            const Divider(),

            GestureDetector(
                onTap: () {

                },
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      const Text(
                        "Disable push notification",
                        style: TextStyle(fontSize: 15),
                      ),

                      Switch(
                        value: isEnabled ?? false,
                        onChanged: (value) {
                          setState(() {
                            isEnabled = value;
                            OneSignal.shared.disablePush(value);
                          });
                        },
                        activeColor: primary,
                        activeTrackColor: Colors.orangeAccent,
                      )

                    ],
                  ),
                )),


          ],
        ),
      ),
    );
  }
}

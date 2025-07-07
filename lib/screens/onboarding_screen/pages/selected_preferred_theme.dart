import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/core/configs/theme/app_colors.dart';
import 'package:campus_mart/screens/option_screen/option_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SelectedPreferredTheme extends StatefulWidget {
  const SelectedPreferredTheme({super.key});

  @override
  State<SelectedPreferredTheme> createState() => _SelectedPreferredThemeState();
}

class _SelectedPreferredThemeState extends State<SelectedPreferredTheme> {
  @override
  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white24,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark
    ));
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: size.width*.1),
          decoration: const BoxDecoration(

          ),
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
            return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Spacer(),

               const SizedBox(
                width: 100,
                height: 100,
                child:  Image(image: AssetImage('assets/logo_orange.png',
                ),),
              ),

              Container(
                margin: const EdgeInsets.only(top: 50, bottom: 20),
              ),

              const Spacer(),

              const Text("Choose Mode",
                textAlign: TextAlign.center, style: TextStyle(color: primary,fontSize: 23),),

              const SizedBox(height: 50,),

               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Column(
                    children: [
                      CircleAvatar(
                      radius: 36,
                      backgroundColor: provider.isDark ? Colors.orangeAccent : AppColors.lightBackground,
                      child: IconButton(
                        onPressed: (){
                          provider.switchTheme(true);
                        },
                        icon: Icon(Icons.dark_mode_outlined, size: 53,
                            color: !provider.isDark ? Colors.orangeAccent : Colors.white
                        ))),
                      const SizedBox(height: 20,),
                      const Text("Dark Mode")
                    ],
                  ),

                  const SizedBox(width: 20,),

                  Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: !provider.isDark ? Colors.orangeAccent : AppColors.darkBackground,
                        child: IconButton(
                            onPressed: (){
                              provider.switchTheme(false);
                            },
                            icon:  Icon(Icons.light_mode_outlined, size: 53,
                            color: provider.isDark ? Colors.orangeAccent : Colors.white,
                            )),
                      ),
                      const SizedBox(height: 20,),
                      const Text("Light Mode")
                    ],
                  )

                ],
              ),

              const SizedBox(height: 50,),

              GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_)=> const OptionScreen())
                    );
                  },
                  child:Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            primary,
                            secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 50),
                    width: size.width,
                    child: const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center,),
                  )),

              const Spacer(),

            ],
          );
          },
        ),
        )

    );
  }
}

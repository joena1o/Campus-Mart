import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/AdScreen/AdScreen.dart';
import 'package:campus_mart/Screens/VerifyEmailScreen/VerifyEmailScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, required this.index, required this.callback})
      : super(key: key);

  final int index;
  final Function callback;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  UserModel? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = context.read<UserProvider>().userDetails;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: size.height * .07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                context.read<ProductProvider>().resetMyProduct();
                widget.callback(1);
              },
              icon: widget.index == 1
                  ? const FaIcon(FontAwesomeIcons.house, color: Colors.orange, size: 20,)
                  : const FaIcon(FontAwesomeIcons.house, color: Colors.black54, size: 20,)),
          IconButton(
              onPressed: () {
                widget.callback(2);
              },
              icon: widget.index == 2
                  ? const FaIcon(
                FontAwesomeIcons.solidHeart,
                color: Colors.orange,
                size: 20,
              )
                  : const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.black54,
                        size: 20,
                    )),
          GestureDetector(
              onTap: () {
                user!.emailVerified! ?  Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdScreen())) :
                showMessageWithButton("Verify your email address", context, (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_)=> const VerifyEmailScreen())
                  );
                });
              },
              child: const FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.grey,
                size: 35,
              )),

          IconButton(
              onPressed: () {
                widget.callback(3);
              },
              icon: widget.index == 3
                  ? const FaIcon(FontAwesomeIcons.solidBell, color: Colors.orange,
                      size: 20,
                    )
                  : const FaIcon(
                      FontAwesomeIcons.solidBell,
                      color: Colors.black54,
                      size: 20,
                    )),
          IconButton(
              onPressed: () {
                widget.callback(4);
              },
              icon: widget.index == 4
                  ? const Icon(
                      Icons.person,
                color: Colors.orange,
                size: 27,
                    )
                  : const Icon(
                      Icons.person,
                      size: 27,
                      color: Colors.black54,
                    ))
        ],
      ),
    );
  }
}

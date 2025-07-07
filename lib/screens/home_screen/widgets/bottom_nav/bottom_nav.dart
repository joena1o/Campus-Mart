import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/screens/ad_screen/ad_screen.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/screens/verify_email_screen/verify_email_screen.dart';
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
    super.initState();
    user = context.read<UserProvider>().userDetails;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
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
                  : const FaIcon(FontAwesomeIcons.house, size: 20,)),
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
                        size: 20,
                    )),
          GestureDetector(
              onTap: () {
                user!.emailVerified! ?  Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const AdScreen())) :
                showMessageWithButton("Verify your email address", (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_)=> const VerifyEmailScreen())
                  );
                });
              },
              child: const FaIcon(
                FontAwesomeIcons.plus,
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
                    ))
        ],
      ),
    );
  }
}

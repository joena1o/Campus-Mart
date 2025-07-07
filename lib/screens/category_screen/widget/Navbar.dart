import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key, required this.categoryPage}) : super(key: key);

  final bool categoryPage;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
      return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: provider.isDark ? AppColors.darkAccent : AppColors.lightAccent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.keyboard_arrow_left, size: 35,)),

           Expanded(child:SizedBox(
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search here",
                hintStyle: TextStyle(fontSize: 14),
            ),
             onSubmitted: (String? text){

               !widget.categoryPage ? Provider.of<ProductProvider>(context, listen: false).searchProduct(text,
                   context.read<AuthProvider>().accessToken, context)
                   : Provider.of<ProductProvider>(context, listen: false).searchProductByCategory(text,
                   context.read<AuthProvider>().accessToken, context);

               Provider.of<ProductProvider>(context, listen: false).saveSearch({
                 "user_id": context.read<UserProvider>().userDetails?.id,
                 "keyword": text
               },  context.read<AuthProvider>().accessToken);

             },
          ))),

        ],
      ),
      );
      },
    );
  }
}

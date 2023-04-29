import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(child:Column(
      children: [

        Container(height: kToolbarHeight*2,),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width:100,
            height:100,
            color: Colors.black,
          ),
        ),

        Container(
          height: 20,
        ),

        Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("${userDetails?.firstName} ${userDetails?.lastName}")),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Icon(Icons.location_on),
            Container(width:10),
            Text("${userDetails?.campus}")
          ],
        ),

        Container(
          height: 20,
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text("My Ads", style: TextStyle(fontSize: 15, color: primary),),
                Text("0",  style: TextStyle(fontSize: 20)),
              ],
            ),



            Container(width: 1,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              decoration: const BoxDecoration(
                color: Colors.grey
              ),
            ),

            Column(
              children: const [
                Text("Reviews", style: TextStyle(fontSize: 15, color: primary)),
                Text("0", style: TextStyle(fontSize: 20)),
              ],
            )
          ],
        ),

        Container(
          height: 10,
        ),

        Container(
          width: size.width*.65,
          padding: const EdgeInsets.symmetric(vertical: 20),
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width*.65,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("My Ads", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),

              const Divider(color: Colors.grey),


              Container(
                width: size.width*.65,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Reviews", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),

              const Divider(color: Colors.grey),

              Container(
                width: size.width*.65,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Alerts", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),

              const Divider(color: Colors.grey),

              Container(
                width: size.width*.65,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Edit Profile", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),

              // const Divider(color: Colors.grey)


            ],
        ))




        // const AdGrid()


      ],
    ));
  }
}

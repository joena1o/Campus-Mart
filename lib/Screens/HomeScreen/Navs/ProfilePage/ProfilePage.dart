import 'dart:convert';
import 'dart:io';
import 'package:campus_mart/Screens/AdAlertScreen/AdAlerts.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/ImageWidget/ImageWidget.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:http/http.dart' as http;
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/EditProfileScreen/EditProfileScreen.dart';
import 'package:campus_mart/Screens/MyAdScreen/MyAdScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{

  File? _images;

  @override
  Widget build(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(child:Column(
      children: [

        Container(height: kToolbarHeight*1.5,),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: GestureDetector(
            onTap: (){
              showUploadDialog();
            },
            child: Consumer<UserProvider>(builder: (_, data, __) {
              return data.userDp !="" ? SizedBox(
            width:100,
            height:100,
            // color: Colors.black,
            child: ImageWidget(url: data.userDp,),
          ) :  Container(
              width:100,
              height:100,
              color: Colors.black45,
              child: const Icon(Icons.person, color: Colors.white, size: 45,),
            );})
        )),

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
          height: 30,
        ),


        Container(
          height: 20,
        ),

        Container(
          width: size.width*.70,
          padding: const EdgeInsets.symmetric(vertical: 20),
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              GestureDetector(
                  onTap:(){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> const MyAdScreen())
                    );
                  },
                  child:Container(
                  width: size.width*.75,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("My Ads", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              )),

              const Divider(color: Colors.grey),


              Container(
                width: size.width*.75,
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

            GestureDetector(
              onTap:(){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_)=> const AdAlerts())
                );
              },
              child:Container(
                width: size.width*.75,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Alerts", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              )),

              const Divider(color: Colors.grey),

              GestureDetector(
                onTap:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> const EditProfileScreen())
                  );
                },
                child:Container(
                width: size.width*.75,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Edit Profile", style: TextStyle(fontSize: 16),),
                    Icon(Icons.chevron_right)
                  ],
                ),
              )),


            ],
        ))



      ],
    ));
  }

  void _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFiles != null) {
      setState(() {
        _images = File(pickedFiles.path);
        _uploadImages();
      });
    }
  }

  void _snapImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickImage(source: ImageSource.camera);
    if (pickedFiles!=null) {
      setState(() {
        _images = File(pickedFiles.path);
        _uploadImages();
      });
    }
  }


  _uploadImages() async {
    showLoadingDialog();
    final url = Uri.parse('$conn/upload-images');
    http.MultipartRequest request = http.MultipartRequest('POST', url);
      final multipartFile = await http.MultipartFile.fromPath(
        "image", _images!.path,
      );
      request.files.add(multipartFile);

    await request.send().then((value) async{
      if(value.statusCode == 200) {
        final responseString = await value.stream.bytesToString();
        final connValue = jsonDecode(responseString);
        updateUser(connValue);
        return responseString;
      } else {
        Navigator.pop(context);
        return "Failed";
      }
    });


  }

  updateUser(connValue){
    context.read<UserProvider>().updateDp(
        context.read<UserProvider>().userDetails?.email,
        connValue['data'][0]['url'],
        context);
  }

  showUploadDialog(){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  CupertinoAlertDialog(
          title:  const Text(
            "Choose action", style: TextStyle(fontSize: 14),),
          content: Column(
            children: const [
              Text(
                  "Upload either from gallery or camera"),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                onPressed: () async {
                  Navigator.pop(context);
                  _pickImages();
                },
                isDefaultAction: true,
                child: const Text("Gallery", style: TextStyle(color: primary),)
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _snapImage();
              },
              child: const Text("Camera", style: TextStyle(color: secondary),),
            )
          ],
        );
      },
    );
  }


  showLoadingDialog(){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  WillPopScope(child: const Center(child:CircularProgressIndicator()),

            onWillPop: () async{
              return false;
            });
      },
    );
  }

}

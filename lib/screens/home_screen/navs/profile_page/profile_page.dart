import 'dart:convert';
import 'dart:io';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Utils/ads_ad_unit.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/core/configs/theme/app_colors.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _images;
  BannerAd? _bannerAd;

  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;
    return Column(
      children: [
        Container(
          height: kToolbarHeight * 1.5,
        ),
        Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: GestureDetector(onTap: () {
                  showUploadDialog();
                }, child: Consumer<UserProvider>(builder: (_, data, __) {

                  return data.userDp != ""
                      ? SizedBox(
                          width: 100,
                          height: 100,
                          // color: Colors.black,
                          child: ImageWidget(
                            url: data.userDp,
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.black45,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 45,
                          ),
                        );
                }))),

                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.lightBackground,
                    child: Icon(Icons.edit, color: Colors.black, ),
                  ),
                )

          ],
        ),

        Container(
          height: 20,
        ),

        10.height,

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on),
            Container(width: 10),
            Text("${userDetails?.campus}")
          ],
        ),

        Container(
          height: 50,
        ),


        Container(
          margin: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("First Name ", style: TextStyle(
                      fontWeight: FontWeight.w600
                  )),
                  Text("${userDetails?.firstName}"),
                ],
              ),

              const SizedBox(height: 5,),

              const Divider(),

              const SizedBox(height: 20,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Last Name ", style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),),
                  Text("${userDetails?.lastName}"),
                ],
              ),

              const SizedBox(height: 5,),

              const Divider(),

              const SizedBox(height: 20,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("State", style: TextStyle(
                      fontWeight: FontWeight.w600
                  )),
                  Text("${userDetails?.state}"),
                ],
              ),

              const SizedBox(height: 5,),

              const Divider(),


            ],
          ),
        ),



        _bannerAd == null
            // Nothing to render yet.
            ? const SizedBox()
            // The actual ad.
            : AdWidget(ad: _bannerAd!)

      ],
    );
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
    if (pickedFiles != null) {
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
    request.headers['Authorization'] = context.read<AuthProvider>().accessToken;
    final multipartFile = await http.MultipartFile.fromPath(
      "image",
      _images!.path,
    );
    request.files.add(multipartFile);
    await request.send().then((value) async {
      if (value.statusCode == 200) {
        final responseString = await value.stream.bytesToString();
        final connValue = jsonDecode(responseString);
        updateUser(connValue);
        return responseString;
      } else {
        closeView();
        return "Failed";
      }
    });
  }

  updateUser(connValue) {
    context.read<UserProvider>().updateDp(
        context.read<UserProvider>().userDetails?.email,
        connValue['data'][0]['url'],
        context.read<AuthProvider>().accessToken,
        context);
  }

  showUploadDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Choose action",
            style: TextStyle(fontSize: 14),
          ),
          content: const Column(
            children:  [
              Text("Upload either from gallery or camera"),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                onPressed: () async {
                  Navigator.pop(context);
                  _pickImages();
                },
                isDefaultAction: true,
                child: const Text(
                  "Gallery",
                  style: TextStyle(color: primary),
                )),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _snapImage();
              },
              child: const Text(
                "Camera",
                style: TextStyle(color: secondary),
              ),
            )
          ],
        );
      },
    );
  }

  showLoadingDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
            child: const Center(child: CircularProgressIndicator()),
            onWillPop: () async {
              return false;
            });
      },
    );
  }

  void _loadAd() {
    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnit,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  void closeView(){
    Navigator.of(context).pop();
  }
}

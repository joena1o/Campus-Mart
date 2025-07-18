import 'dart:convert';
import 'dart:io';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/error_model.dart';
import 'package:campus_mart/model/payment_type_model.dart';
import 'package:campus_mart/model/pre_paid_product_model.dart';
import 'package:campus_mart/model/product_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/network/product_class/product_class.dart';
import 'package:campus_mart/screens/ad_screen/success_screen.dart';
import 'package:campus_mart/Utils/categories.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdScreen extends StatefulWidget {
  const AdScreen({Key? key}) : super(key: key);
  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  BannerAd? _bannerAd;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  //final plugin = PaystackPayment();

  bool contact = false;
  bool negotiable = false;
  ProductModel productModel = ProductModel();
  ProductClass product = ProductClass();

  UserModel userDetails = UserModel();
  PrePaidProductModel? prePaidProductModel;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? itemCategory;

  List<XFile>? images;

  bool isUploading = false;

  bool isSuccessful = false;

  bool processingPayment = false;

  @override
  void initState() {
    // plugin.initialize(publicKey: dotenv.env['PAY_STACK_PUBLIC_KEY_LIVE']!);

    productModel.userId = context.read<UserProvider>().userDetails!.id;
    productModel.campus = context.read<UserProvider>().userDetails!.campus;
    productModel.countryId =
        context.read<UserProvider>().userDetails!.countryId;
    productModel.state = context.read<UserProvider>().userDetails!.state;
    productModel.contactForPrice = false;
    productModel.negotiable = false;

    _loadAd();

    super.initState();
  }

  List<File> _images = [];

  List<PaymentTypeModel> paymentPlan = [
    PaymentTypeModel(
        value: "Premium", text: "Premium Ad - N500", amount: 50000),
    PaymentTypeModel(
        value: "Standard", text: "Standard Ad - N200", amount: 20000),
    PaymentTypeModel(value: "Free", text: "Basic Ad - FREE", amount: 0),
  ];

  PaymentTypeModel? selectPayment;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isSuccessful
        ? const SuccessScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "Post an ad",
                style: TextStyle(fontSize: 15),
              ),
              foregroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: 30,
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: SizedBox(
                width: size.width,
                height: size.height * .9,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    SizedBox(
                        child: DropdownButton<PaymentTypeModel>(
                      value: selectPayment,
                      hint: SizedBox(
                          width: size.width * .8,
                          child: const Text("Select Ad Type")),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: Container(),
                      items: paymentPlan
                          .map((PaymentTypeModel e) => DropdownMenuItem(
                              value: e,
                              child: SizedBox(
                                  width: size.width * .8,
                                  child: Text(e.text.toString()))))
                          .toList(),
                      onChanged: (PaymentTypeModel? newValue) {
                        setState(() => productModel.adType = newValue!.value);
                        setState(() => selectPayment = newValue);
                      },
                    )),
                    const Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                        child: DropdownButton(
                      value: itemCategory,
                      hint: SizedBox(
                          width: size.width * .8,
                          child: const Text("Select Ad Category")),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: Container(),
                      items: categories.map((val) {
                        return DropdownMenuItem(
                            value: val,
                            child: SizedBox(
                                width: size.width * .8, child: Text(val)));
                      }).toList(),
                      onChanged: (dynamic newValue) {
                        setState(() => itemCategory = newValue);
                        setState(() => productModel.adCategory =
                            removeSpecialCharactersAndSpaces(newValue));
                      },
                    )),
                    const Divider(
                      color: Colors.grey,
                    ),
                    TextFormField(
                      controller: title,
                      validator: (String? text) {
                        if (text!.isEmpty) {
                          return "Title is requird";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Title"),
                    ),
                    Container(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (String? text) {
                        if (text!.isEmpty) {
                          return "Please enter product description";
                        }
                        return null;
                      },
                      controller: description,
                      decoration: const InputDecoration(
                          hintText: "Type description here"),
                      maxLines: 3,
                    ),
                    Container(
                      height: 20,
                    ),
                    SizedBox(
                        child: DropdownButton(
                      value: productModel.condition,
                      hint: SizedBox(
                          width: size.width * .8,
                          child: const Text("Describe item condition")),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: Container(),
                      items: [
                        DropdownMenuItem(
                            value: "New",
                            child: SizedBox(
                                width: size.width * .8,
                                child: const Text("New"))),
                        DropdownMenuItem(
                            value: "Refurbished",
                            child: SizedBox(
                                width: size.width * .8,
                                child: const Text("Refurbished"))),
                        DropdownMenuItem(
                            value: "Used",
                            child: SizedBox(
                                width: size.width * .8,
                                child: const Text("Used"))),
                      ],
                      onChanged: (dynamic newValue) {
                        setState(() => productModel.condition = newValue);
                      },
                    )),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Container(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: (productModel.contactForPrice) ?? false,
                                onChanged: (bool? val) {
                                  setState(() =>
                                      productModel.contactForPrice = val!);
                                }),
                            const Text("Contact for price")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: (productModel.negotiable) ?? false,
                                onChanged: (bool? val) {
                                  setState(
                                      () => productModel.negotiable = val!);
                                }),
                            const Text("Negotiable")
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                        visible: !productModel.contactForPrice!,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (String? text) {
                            if (text!.isEmpty &&
                                productModel.contactForPrice == false) {
                              return "Please enter price";
                            }
                            return null;
                          },
                          controller: price,
                          decoration:
                              const InputDecoration(hintText: "Price: N"),
                        )),
                    Container(
                      height: 20,
                    ),
                    Container(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          child: (TextButton.icon(
                              onPressed: () {
                                showUploadDialog();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Upload images"))),
                        )
                      ],
                    ),
                    SizedBox(
                        height: 100,
                        width: 50,
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: _images.map((image) {
                            return Image.file(image, fit: BoxFit.contain);
                          }).toList(),
                        )),
                    Container(
                      height: 10,
                    ),
                    _bannerAd == null
                        // Nothing to render yet.
                        ? const SizedBox()
                        : SizedBox(height: 50, child: AdWidget(ad: _bannerAd!)),
                    Container(
                      height: 10,
                    ),
                    !isUploading
                        ? GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(10)),
                              width: size.width * .8,
                              child: const Text(
                                "Upload Ad",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                if (selectPayment?.value == "Free") {
                                  _images.isNotEmpty
                                      ? _uploadImages(false)
                                      : {uploadProduct()};
                                } else {
                                  _images.isNotEmpty
                                      ? _uploadImages(true)
                                      : payStackCheckOut();
                                }
                              }
                            },
                          )
                        : const Center(child: CircularProgressIndicator())
                  ],
                ),
              ),
            ));
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
            children: [
              Text("Upload either from gallery or camera"),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                onPressed: () async {
                  _pickImages();
                },
                isDefaultAction: true,
                child: const Text(
                  "Gallery",
                  style: TextStyle(color: primary),
                )),
            CupertinoDialogAction(
              onPressed: () {
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

  void uploadProduct() {
    setState(() => isUploading = true);
    productModel.title = title.text.toString();
    productModel.description = description.text.toString();
    productModel.price = !productModel.contactForPrice!
        ? int.parse(price.text.toString().replaceAll("N", ""))
        : 0;
    product
        .addProduct(
            productModel.toJson2(), context.read<AuthProvider>().accessToken)
        .then((value) {
      setState(() => isUploading = false);
      // Provider.of<ProductProvider>(context, listen: false).updateProductStatus(true);
      setState(() => isSuccessful = true);
    }).catchError((onError) {
      setState(() => isUploading = false);
      setState(() => isSuccessful = false);
      // Provider.of<ProductProvider>(context, listen: false).updateProductStatus(false);
      ErrorModel error = ErrorModel.fromJson(onError);
      showMessage(error.message);
    });
  }

  void _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 30);
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _snapImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickImage(source: ImageSource.camera);
    if (pickedFiles != null) {
      setState(() {
        _images = [File(pickedFiles.path)];
      });
    }
  }

  Future<List<dynamic>> _uploadImages(bool withPayment) async {
    setState(() => isUploading = true);
    final url = Uri.parse('$conn/upload-images');
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      url,
    );
    request.headers['Authorization'] = context.read<AuthProvider>().accessToken;
    for (final image in _images) {
      final multipartFile = await http.MultipartFile.fromPath(
        "image",
        image.path,
      );
      request.files.add(multipartFile);
    }
    final result = await request.send();
    if (result.statusCode == 200) {
      final respString = await result.stream.bytesToString();
      final connValue = jsonDecode(respString);
      productModel.images = connValue['data'];
      withPayment ? payStackCheckOut() : uploadProduct();
      return connValue['data'];
    } else {
      setState(() => isUploading = false);
      return [];
    }
  }

   Future<void> payStackCheckOut() async {}

  void _loadAd() {
  //   final bannerAd = BannerAd(
  //     size: AdSize.fullBanner,
  //     adUnitId: bannerAdUnit,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       // Called when an ad is successfully received.
  //       onAdLoaded: (ad) {
  //         if (!mounted) {
  //           ad.dispose();
  //           return;
  //         }
  //         setState(() {
  //           _bannerAd = ad as BannerAd;
  //         });
  //       },
  //       // Called when an ad request failed.
  //       onAdFailedToLoad: (ad, error) {
  //         debugPrint('BannerAd failed to load: $error');
  //         ad.dispose();
  //       },
  //     ),
  //   );

  //   // Start loading.
  //   bannerAd.load();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/payment_type_model.dart';
import 'package:campus_mart/model/pre_paid_product_model.dart';
import 'package:campus_mart/model/product_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/network/product_class/product_class.dart';
import 'package:campus_mart/screens/ad_screen/success_screen.dart';
import 'package:campus_mart/Utils/categories.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditAdScreen extends StatefulWidget {
  const EditAdScreen({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  State<EditAdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<EditAdScreen> {
  var publicKey = 'pk_test_c1025aaf085e2f65db15176d53378af42b1b1767';
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
    //plugin.initialize(publicKey: publicKey);

    productModel.userId = context.read<UserProvider>().userDetails!.id;
    productModel.campus = context.read<UserProvider>().userDetails!.campus;
    productModel.countryId =
        context.read<UserProvider>().userDetails!.countryId;
    productModel.state = context.read<UserProvider>().userDetails!.state;
    productModel.condition = widget.product.condition;
    productModel.adType = widget.product.adType;
    productModel.adCategory = widget.product.adCategory;
    productModel.price = widget.product.price;
    productModel.title = widget.product.title;
    productModel.description = widget.product.description;
    productModel.paid = widget.product.paid;
    productModel.id = widget.product.id;
    productModel.negotiable = widget.product.negotiable;
    productModel.images = widget.product.images;

    contact = widget.product.contactForPrice!;
    title.text = widget.product.title!;
    description.text = widget.product.description!;
    itemCategory = widget.product.adCategory;
    negotiable = widget.product.negotiable!;
    price.text = widget.product.price.toString();
    productModel.contactForPrice = widget.product.contactForPrice!;
    selectPayment = paymentPlan
        .where((element) => element.value == widget.product.adType)
        .first;

    super.initState();
  }

  List<File> _images = [];

  List<PaymentTypeModel> paymentPlan = [
    PaymentTypeModel(
        value: "Premium", text: "Premium Ad - N500", amount: 50000),
    PaymentTypeModel(
        value: "Standard", text: "Standard Ad - N200", amount: 50000),
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
                "Edit your ad",
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
                    Visibility(
                      visible: widget.product.adType == "Free",
                      child: SizedBox(
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
                    ),
                    Visibility(
                        visible: widget.product.adType == "Free",
                        child: const Divider(
                          color: Colors.grey,
                        )),
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
                      onChanged: (e) {
                        setState(() => productModel.title = e.toString());
                      },
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
                      onChanged: (e) {
                        setState(() => productModel.description = e.toString());
                      },
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
                          onChanged: (e) {
                            setState(() => productModel.price = !productModel
                                    .contactForPrice!
                                ? int.parse(e.toString().replaceAll("N", ""))
                                : 0);
                          },
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
                    Visibility(
                      visible: _images.isNotEmpty,
                      child: SizedBox(
                          height: 100,
                          width: 50,
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: _images.map((image) {
                              return Image.file(image, fit: BoxFit.contain);
                            }).toList(),
                          )),
                    ),
                    Visibility(
                      visible:
                          _images.isEmpty && widget.product.images!.isNotEmpty,
                      child: SizedBox(
                          height: 100,
                          width: 50,
                          child: GridView.count(
                            crossAxisCount: 3,
                            children: widget.product.images!.map((image) {
                              return Image.network(image['url'],
                                  fit: BoxFit.contain);
                            }).toList(),
                          )),
                    ),
                    Container(
                      height: 15,
                    ),
                    !isUploading
                        ? GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                  color: areObjectsEqual(
                                          widget.product.toJson2(),
                                          productModel.toJson2())
                                      ? Colors.grey
                                      : Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              width: size.width * .8,
                              child: const Text(
                                "Edit Ad",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              areObjectsEqual(widget.product.toJson2(),
                                  productModel.toJson2());
                              // payStackCheckOut();
                              if (!_formKey.currentState!.validate() ||
                                  areObjectsEqual(widget.product.toJson2(),
                                      productModel.toJson2())) {
                                return;
                              } else {
                                if (selectPayment?.value != "Free" &&
                                    widget.product.adType == "Free") {
                                  if (_images.isNotEmpty) {
                                    _uploadImages(true);
                                  }
                                  //payStackCheckOut();
                                } else {
                                  _images.isNotEmpty
                                      ? _uploadImages(false)
                                      : {uploadProduct()};
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
            children:  [
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
    productModel.images = productModel.images ?? widget.product.images;
    Provider.of<ProductProvider>(context, listen: false).editProduct(
        productModel.toJson(), context.read<AuthProvider>().accessToken, () {});
  }

  void _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 30);
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
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
      final resp_string = await result.stream.bytesToString();
      final connValue = jsonDecode(resp_string);
      productModel.images = connValue['data'];
      withPayment
          ? (){}
          //payStackCheckOut()
          : uploadProduct();
      return connValue['data'];
    } else {
      setState(() => isUploading = false);
      return [];
    }
  }

  // payStackCheckOut() async{
  //   final userDetails = context.read<UserProvider>().userDetails;
  //   Charge charge = Charge()
  //     ..amount = selectPayment!.amount!
  //     ..reference = _getReference()
  //   // or ..accessCode = _getAccessCodeFrmInitialization()
  //     ..email = userDetails?.email;
  //   CheckoutResponse response = await plugin.checkout(
  //     context,
  //     fullscreen: false,
  //     //logo: const Image(image: AssetImage("assets/launcher/launcher.png")),
  //     method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
  //     charge: charge,
  //   );
  //   if(response.message == "Success"){
  //     setState(()=> productModel.paid = true);
  //     setState(()=> processingPayment = true);
  //     setState(()=> isSuccessful = true);
  //     uploadProduct();
  //   }else{
  //     setState(()=> productModel.paid = false);
  //   }
  // }

  // String _getReference() {
  //   String platform;
  //   if (!kIsWeb) {
  //     if (Platform.isIOS) {
  //       platform = 'iOS';
  //     } else {
  //       platform = 'Android';
  //     }
  //   } else {
  //     platform = "WEB";
  //   }
  //   return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  // }

  bool areObjectsEqual(Map obj1, Map obj2) {
    // Get the keys of the objects
    List<dynamic> keys1 = obj1.keys.toList();
    List<dynamic> keys2 = obj2.keys.toList();
    // Check if the number of keys is the same
    if (keys1.length != keys2.length) {
      return false;
    }
    // Check if the values for each key are equal
    for (var key in keys1) {
      if (obj1[key] != obj2[key]) {
        return false;
      }
    }
    // If all key-value pairs are equal, return true
    return true;
  }
}

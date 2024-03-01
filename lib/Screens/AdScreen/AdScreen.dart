import 'dart:convert';
import 'dart:io';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/ProductClass/ProductClass.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/Categories.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdScreen extends StatefulWidget {
  const AdScreen({Key? key}) : super(key: key);
  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {

  bool contact = false;
  bool negotiable = false;
  ProductModel productModel = ProductModel();
  ProductClass product = ProductClass();

  UserModel userDetails = UserModel();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? itemCategory;

  List<XFile>? images;

  bool isUploading = false;


  @override
  void initState(){
    super.initState();
    productModel.userId = context.read<UserProvider>().userDetails!.id;
    productModel.campus = context.read<UserProvider>().userDetails!.campus;
    productModel.countryId = context.read<UserProvider>().userDetails!.countryId;
    productModel.contactForPrice = false;
  }

  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Post an ad", style: TextStyle(fontSize: 15),),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.chevron_left, size: 30,),
        ),
      ),
      body: Form(
        key: _formKey,
        child:SizedBox(
        width: size.width,
        height: size.height*.9,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [

            SizedBox(child:DropdownButton(
              value: productModel.adType,
              hint:
              SizedBox(width: size.width*.8, child: const Text("Select Ad Type")),
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: Container(),
              items:  [
                DropdownMenuItem(
                    value: "Basic",
                    child: SizedBox(
                      width: size.width*.8,
                        child: const Text("Premium Ad - N500"))),
                DropdownMenuItem(
                    value: "Standard",
                    child: SizedBox(
                        width: size.width*.8,
                        child: const Text("Standard Ad - N200"))),
                DropdownMenuItem(
                    value: "Premium",
                    child: SizedBox(
                        width: size.width*.8,
                        child: const Text("Basic Ad - Free"))),
              ],
              onChanged: (dynamic newValue) {
                setState(()=> productModel.adType = newValue);
              },
            )),

            const Divider(color: Colors.grey,),

            SizedBox(child:DropdownButton(
              value: itemCategory,
              hint:
              SizedBox(width: size.width*.8, child: const Text("Select Ad Category")),
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: Container(),
              items: categories.map((val) {
                return DropdownMenuItem(
                    value: val,
                    child: SizedBox(
                        width: size.width*.8,
                        child: Text(val))
                );
              }).toList(),
              onChanged: (dynamic newValue) {
                setState(()=>itemCategory = newValue);
                setState(()=> productModel.adCategory = removeSpecialCharactersAndSpaces(newValue));
              },
            )),

            const Divider(color: Colors.grey,),

            TextFormField(
              controller: title,
              validator: (String? text){
                if(text!.isEmpty) {
                  return "Title is requird";
                }
              },
              decoration: const InputDecoration(hintText: "Title"),
            ),
            Container(
              height: 20,
            ),

            TextFormField(
              validator: (String? text){
                if(text!.isEmpty) {
                  return "Please enter product description";
                }
              },
              controller: description,
              decoration: const InputDecoration(hintText: "Type description here"),
              maxLines: 3,
            ),
            Container(
              height: 20,
            ),



            SizedBox(child:DropdownButton(
              value: productModel.condition,
              hint:
              SizedBox(width: size.width*.8, child: const Text("Describe item condition")),
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: Container(),
              items:  [
                DropdownMenuItem(
                    value: "New",
                    child: SizedBox(
                        width: size.width*.8,
                        child: const Text("New"))),
                DropdownMenuItem(
                    value: "Refurbished",
                    child: SizedBox(
                        width: size.width*.8,
                        child: const Text("Refurbished"))),
                DropdownMenuItem(
                    value: "Used",
                    child: SizedBox(
                        width: size.width*.8,
                        child: const Text("Used"))),
              ],
              onChanged: (dynamic newValue) {
                setState(()=> productModel.condition = newValue);
              },
            )),

            const Divider(color: Colors.grey,),

            Container(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Row(
                  children: [
                    Checkbox(value: (productModel.contactForPrice) ?? false,
                        onChanged: (bool? val){
                          setState(()=> productModel.contactForPrice = val!);
                        }),
                    const Text("Contact for price")
                  ],
                ),

                Row(
                  children: [
                    Checkbox(value: productModel.negotiable ?? false,
                        onChanged: (bool? val){
                          setState(()=> productModel.negotiable = val!);
                        }),
                    const Text("Negotiable")
                  ],
                ),

              ],
            ),

            Visibility(
                visible: !productModel.contactForPrice!,
                child:TextFormField(
                keyboardType: TextInputType.number,
                validator: (String? text){
                if(text!.isEmpty && productModel.contactForPrice==false) {
                  return "Please enter price";
                }
              },
              controller: price,
              decoration: const InputDecoration(hintText: "Price: N"),
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
                      child: (TextButton.icon(onPressed: (){
                        showUploadDialog();
                        },
                          icon: const Icon(Icons.add), label: const Text("Upload images"))),
                    )
              ],
            ),

        SizedBox(
          height: 100,
          width: 50,
          child: GridView.count(
            crossAxisCount: 3,
            children: _images.map((image) {
              return Image.file(image, fit:BoxFit.contain);
            }).toList(),
          )),

            Container(
              height: 10,
            ),

            !isUploading ? GestureDetector(child:Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(10)
              ),
              width: size.width*.8,
              child: const Text("Upload Ad", style: TextStyle(color:Colors.white),),
            ), onTap: (){
              if(!_formKey.currentState!.validate()){
                  return;
              }else{
                _images.isNotEmpty ? _uploadImages() : uploadProduct();
              }
            },):const Center(
              child: CircularProgressIndicator()
            )

          ],
        ),
      ),
    ));
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
                  _pickImages();
                },
                isDefaultAction: true,
                child: const Text("Gallery", style: TextStyle(color: primary),)
            ),
            CupertinoDialogAction(
              onPressed: () {
                _snapImage();
              },
              child: const Text("Camera", style: TextStyle(color: secondary),),
            )
          ],
        );
      },
    );
  }

  uploadProduct(){
    productModel.title = title.text.toString();
    productModel.description = description.text.toString();
    productModel.price = !productModel.contactForPrice! ? int.parse(price.text.toString().replaceAll("N","")):0;
    product.addProduct(productModel.toJson2(), context.read<AuthProvider>().accessToken)
    .then((value){
      setState(()=> isUploading = false);
      showMessage(value['message'], context);
      finish(context);
    }).catchError((onError){
      setState(()=> isUploading = false);
      ErrorModel error = ErrorModel.fromJson(onError);
      showMessage(error.message, context);
    });

  }

  void _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 30
    );
    if (pickedFiles != null) {
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
            // pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

   _uploadImages() async {
    setState(()=> isUploading = true);
    final url = Uri.parse('$conn/upload-images');
    http.MultipartRequest request = http.MultipartRequest('POST', url,);
    for (final image in _images) {
      final multipartFile = await http.MultipartFile.fromPath(
        "image", image.path,
      );
      request.files.add(multipartFile);
    }
  await request.send().then((value) async{
    if(value.statusCode == 200) {
      final resp_string = await value.stream.bytesToString();
      final connValue = jsonDecode(resp_string);
      print(connValue['data']);
      productModel.images = connValue['data'];
      uploadProduct();
      return resp_string;
    } else {
      setState(()=> isUploading = false);
      return "Failed";
    }
    });
  }

}

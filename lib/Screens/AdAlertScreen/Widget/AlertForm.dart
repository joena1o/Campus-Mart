import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/Categories.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertForm extends StatefulWidget {
  const AlertForm({Key? key}) : super(key: key);

  @override
  State<AlertForm> createState() => _AlertFormState();
}

class _AlertFormState extends State<AlertForm> {

  TextEditingController title = TextEditingController();
  String? category;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [

        const SizedBox(height: 40,),

        SizedBox(child:DropdownButton(
          value: category,
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
            setState(()=> category = newValue);
          },
        )),

        Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child:const Divider(color: Colors.black,)),

        Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child:TextFormField(
            controller: title,
            validator: (String? text){
              if(text!.isEmpty) {
                return "Title is requird";
              }
          },
          decoration: const InputDecoration(hintText: "Title"),
        )),

        const SizedBox(height: 100,),

    Consumer<ProductProvider>(
    builder: (_, bar, __) {
    return !bar.isUploadingAlert ? GestureDetector(child:Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(10)
          ),
          width: size.width*.8,
          child: const Text("Create", style: TextStyle(color:Colors.white),),
        ), onTap: (){
              context.read<ProductProvider>().addAdAlert(context, {
                "userId": context.read<UserProvider>().userDetails?.id.toString(), "category": removeSpecialCharactersAndSpaces(category.toString()), "item": title.text.toString(),
              }, context.read<UserProvider>().userDetails?.id.toString(), context.read<AuthProvider>().accessToken);
        },):const Center(
          child: CircularProgressIndicator(),
          ); })

      ],
    );
  }
}

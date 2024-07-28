import 'dart:convert';
import 'package:campus_mart/Model/CampusModel.dart';
import 'package:campus_mart/Model/CountryModel.dart';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/StateModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Provider/sign_up_provider.dart';
import 'package:campus_mart/Screens/LoginScreen/LoginScreen.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field2/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  int position = 0;
  PageController? pageController;
  String? state;
  String? campus;
  String? country;
  String? countryCode;

  bool validatingMail = false;
  bool validatingUser = false;
  Auth auth =  Auth();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  List<dynamic> campusList = [];

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    init();
    Provider.of<SignUpProvider>(context, listen: false).fetchCountries(context);
  }

  Future<void> init() async {
    pageController = PageController(initialPage: position, viewportFraction: 1);
  }

  void nextPage(){
    position++;
    pageController!.nextPage(
        duration: const Duration(microseconds: 300),
        curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [firstStep(size), secondStep(size)]),
    );
  }

  Widget firstStep(size) {
    return SingleChildScrollView(child:Form(
    key: _formKey,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: kToolbarHeight * 2,
          ),

          const Text("Create an account",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),

          Container(
            height: 10,
          ),

          const Text("Let's get started", style: TextStyle(fontSize: 16)),

          Container(
            height: 30,
          ),

          TextFormField(
            controller: firstName,
            validator: (String? value){
              if(value!.isEmpty || value.length < 2){
                showMessage("Please enter valid first name");
                return "Please enter valid first name";
              }
              return null;
            },
            decoration: const InputDecoration(hintText: "First Name"),
          ),

          Container(
            height: 20,
          ),

          TextFormField(
            controller: lastName,
            validator: (String? value){
              if(value!.isEmpty || value.length < 2){
                showMessageError("Please enter valid last name");
                return "Please enter valid last name";
              }
              return null;
            },
            decoration: const InputDecoration(hintText: "Last Name"),
          ),

          Container(
            height: 20,
          ),

          TextFormField(
            controller: email,
            validator: (String? value){
              if(value!.isEmpty){
                showMessageError("Please enter valid email address");
                return "Please enter valid email address";
              }
              return null;
            },
            decoration: const InputDecoration(hintText: "Email Address"),
          ),

          Container(
            height: 20,
          ),

          TextFormField(
            controller: username,
            validator: (String? value){
              if(value!.isEmpty){
                showMessageError("Please enter a preferred display name");
                return "Please enter a preferred display name";
              }
              return null;
            },
            decoration:
            const InputDecoration(hintText: "Enter preferred display name "),
          ),

          Container(
            height: 20,
          ),

          Consumer<SignUpProvider>(builder: (_, data, __) { return !data.loadingCountries ?  Column(
            children: [
              DropdownButton<String>(
                value: country,
                hint: SizedBox(width: size.width * .75, child: const Text("Select Country")),
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: Container(),
                items: data.countries?.map((CountryModel item) {
                  return DropdownMenuItem<String>(
                    value: item.countryModelId,
                    child: SizedBox(width: size.width * .75, child: Text(item.name.toString())),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(()=> country = newValue);
                  setState(()=> countryCode = data.countries!.firstWhere((element) => element.countryModelId == newValue).countryCode);
                  context.read<SignUpProvider>().fetchStates(context, newValue);
                },
              ),

              Visibility(
                  visible: !data.loadingCountries,
                  child: const Divider(color: Colors.black)),

            ],
          ):  Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              child: const CircularProgressIndicator());
            }
          ),



          Container(
            height: 20,
          ),

          !validatingMail ? GestureDetector(
            onTap: () {
              if(_formKey.currentState!.validate()){
                if(country == null || country!.isEmpty){
                  showMessageError("Please select your country");
                  return;
                }
                validateEmail(email.text.toString(), context);
              }
            },
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(20),
                width: size.width,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        primary,
                        secondary,
                      ],
                    ),
                    color: primary,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text("Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 17))),
          ): const Center(
            child: CircularProgressIndicator(),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                    onTap: ()=>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen())),
                    child: const Text("Sign In", style: TextStyle(color: primary),)
                )
              ],
            ),
          ),

          Container(
            height: size.height * .07,
          ),

        ],
      ),
    )));
  }


  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController phone = TextEditingController();

  Widget secondStep(size) {
    return SingleChildScrollView(
        child: Form(
            key: _formKey2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * .08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                Container(
                height: kToolbarHeight * 2,
                ),

                const Text("Create an account",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),

                Container(
                height: 10,
                ),

                const Text("Lastly, ", style: TextStyle(fontSize: 16)),

                Container(
                  height: 30,
                ),


              Consumer<SignUpProvider>(builder: (_, data, __) { return !data.loadingStates ? DropdownButton<String>(
                    value: state,
                    hint:
                    SizedBox(width: size.width - 90 , child: const Text("Select State")),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    underline: Container(),
                    items: data.states.map((StateModel item) {
                      return DropdownMenuItem<String>(
                        value: item.state,
                        child: SizedBox(width: size.width - 90, child: Text(item.state.toString())),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(()=> state = newValue);
                      context.read<SignUpProvider>().fetchCampuses(newValue, context);
                    },
                  ): const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

                  const Divider(color: Colors.black),

                  Container(
                    height: 20,
                  ),

                  Consumer<SignUpProvider>(builder: (_, data, __) { return !data.loadingCampus ? Column(
                    children: [
                      DropdownButton(
                        value: campus,
                        hint: SizedBox(width: size.width - 90, child: data.campuses.toList().isEmpty ? const Text("Fetching Campuses")
                            : const Text("Select Campus")),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: Container(),
                        items: data.campuses.map((Campus item) {
                          return DropdownMenuItem(
                            value: item.campus,
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                width: size.width - 90, child: Text(item.campus.toString())),
                          );
                        }).toList(),
                        onChanged: (dynamic newValue) {
                          setState(()=> campus = newValue);
                        },
                      ),

                      Visibility(
                          visible: !data.loadingCampus,
                          child: const Divider(color: Colors.black)),

                    ],
                  ) : const Center(child:CircularProgressIndicator()); }),


                  const SizedBox(height: 20,),

                  IntlPhoneField(
                    controller: phone,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 14
                      ),
                     // border: InputBorder.none
                    ),
                    initialCountryCode: countryCode,
                    flagWidth: 100,
                    flagsButtonMargin: const EdgeInsets.only(top: 20, bottom: 20),
                    textFieldPadding:  const EdgeInsets.only(top: 22, bottom: 20),
                    showCountryFlag: true,
                    validator: (value){
                      if(value!.number.isEmpty){
                        showMessageError("Please enter a valid phone number");
                        return "Please enter a valid valid phone number";
                      }
                      return null;
                    },
                  ),


                Container(
                  height: 20,
                ),

                TextFormField(
                  controller: password,
                  obscureText: showPassword,
                  validator: (String? value){
                    if(value!.isEmpty){
                      showMessageError("Please enter password");
                      return "Please enter password";
                    }
                    return null;
                  },
                  decoration:
                   InputDecoration(
                      suffixIcon: IconButton(onPressed: (){
                        setState(()=> showPassword = !showPassword);
                      }, icon: showPassword ? const Icon(FontAwesomeIcons.eye, size: 15,): const Icon(FontAwesomeIcons.eyeSlash, size: 15,)),
                      hintText: "Enter password"),
                ),

                Container(
                  height: 40,
                ),

                TextFormField(
                  controller: cPassword,
                  obscureText: showPassword,
                  validator: (String? value){
                    if(value!.isEmpty){
                      showMessageError("Please confirm password");
                      return "Please confirm password";
                    }
                    return null;
                  },
                  decoration:
                   InputDecoration(
                      suffixIcon: IconButton(onPressed: (){
                        setState(()=> showPassword = !showPassword);
                      }, icon: showPassword ? const Icon(FontAwesomeIcons.eye, size: 15,): const Icon(FontAwesomeIcons.eyeSlash, size: 15,)),
                      hintText: "Confirm password"),
                ),
                Container(
                  height: 20,
                ),

                  Consumer<SignUpProvider>(builder: (_, data, __) { return !data.getSigningUser ? GestureDetector(
                  onTap: () {
                    if(phone.text.isEmpty || phone.text.length < 10){
                      showMessageError("Enter a valid phone number");
                      return;
                    }
                    if(cPassword.text != password.text){
                      showMessageError("Password do not match");
                      return;
                    }
                    if(_formKey2.currentState!.validate()) {
                      UserModel userModel = UserModel(firstName: firstName.text.toString(), countryId: country,
                      lastName: lastName.text.toString(), email: email.text.toString(), password: password.text.toString(),
                            state: state, campus: campus, username: username.text.toString(), phone: phone.text.toString(),
                            emailVerified: false
                          );
                      context.read<SignUpProvider>().signUpUser(userModel.toJson2(), context);
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      padding: const EdgeInsets.all(20),
                      width: size.width,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.topLeft,
                            colors: [
                              primary,
                              secondary,
                            ],
                          ),
                          color: primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text("Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17))),
                ):
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                ;}),


                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                          onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen())),
                          child: const Text("Sign In", style: TextStyle(color: primary),)
                      )
                    ],
                  ),
                )
      ],
    ),)));

  }

  void validateEmail(email,context){
    validatingMail = true;
    auth.validateMail(email).then((value){
      validatingMail = false;
      nextPage();
    }).catchError((onError){
      validatingMail = false;
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message);
    });
  }

}


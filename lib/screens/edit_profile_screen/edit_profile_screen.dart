import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/sign_up_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Utils/states.dart';
import 'package:campus_mart/model/campus_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field2/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? state;
  String? campus;

  bool validatingMail = false;
  bool validatingUser = false;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();

  String? countryCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? currentDate;

  @override
  void initState() {
    super.initState();

    firstName.text = context.read<UserProvider>().userDetails!.firstName!.toString();
    lastName.text = context.read<UserProvider>().userDetails!.lastName!.toString();
    phone.text = "${context.read<UserProvider>().userDetails!.phone}";
    state = context.read<UserProvider>().userDetails!.state;
    campus = context.read<UserProvider>().userDetails!.campus;
    context.read<SignUpProvider>().fetchCampuses(state, context);

    currentDate = {
      "email": context.read<UserProvider>().userDetails!.email,
      "firstName": context.read<UserProvider>().userDetails!.firstName!.toString(),
      "lastName": context.read<UserProvider>().userDetails!.lastName!.toString(),
      "state": context.read<UserProvider>().userDetails!.state,
      "phone": context.read<UserProvider>().userDetails!.phone,
      "campus": context.read<UserProvider>().userDetails!.campus,
    };

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Profile",
            style: TextStyle(fontSize: 15),
          ),
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
        body: SingleChildScrollView(
          child: Container(
              width: size.width,
              height: size.height * .9,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                    ),
                    TextFormField(
                      controller: firstName,
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 2) {
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
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 2) {
                          showMessage("Please enter valid last name");
                          return "Please enter valid last name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Last Name"),
                    ),
                    Container(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      value: state,
                      hint: SizedBox(
                          width: size.width-70,
                          child: const Text("Select State")),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: Container(),
                      items: states.map((dynamic item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: SizedBox(
                              width: size.width -70, child: Text(item)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() => state = newValue);
                        setState(()=> campus = null);
                        context
                            .read<SignUpProvider>()
                            .fetchCampuses(newValue, context);
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 4,
                    ),
                    Container(
                      height: 20,
                    ),
                    Consumer<SignUpProvider>(builder: (_, data, __) {
                      return !data.loadingCampus
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButton<String>(
                                  value: campus,
                                  hint: SizedBox(
                                      //width: size.width * .75,
                                      child: data.campuses.toList().isEmpty
                                          ? const Text("Fetching Campuses")
                                          : const Text("Select Campus")),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  underline: Container(),
                                  items: data.campuses.map((Campus item) {
                                    return DropdownMenuItem<String>(
                                      value: item.campus,
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: size.width - 70,
                                          child: Text(item.campus.toString())),
                                    );
                                  }).toList(),
                                  onChanged: (dynamic newValue) {
                                    setState(() => campus = newValue);
                                    validateEdit();
                                  },
                                ),
                                const Divider(
                                  color: Colors.black,
                                  height: 4,
                                ),
                              ],
                            )
                          : const Center(child: CircularProgressIndicator());
                    }),
                    Container(
                      height: 20,
                    ),
          
                    IntlPhoneField(
                      controller: phone,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: 14
                        ),
                        // border: InputBorder.none
                      ),
                      initialCountryCode: "NG",
                      flagWidth: 140,
                      flagsButtonMargin: const EdgeInsets.only(top: 20, bottom: 20),
                      textFieldPadding:  const EdgeInsets.only(top: 22, bottom: 20),
                      showCountryFlag: true,
                      validator: (value){
                        if(value!.number.isEmpty){
                          showMessage("Please enter a valid phone number");
                          return "Please enter a valid valid phone number";
                        }
                        return null;
                      },
                    ),
          
                    const Spacer(),
          
                    Consumer<SignUpProvider>(builder: (_, data, __) {
                      return GestureDetector(
                          onTap: () {
                            if (validateEdit() &&
                                _formKey.currentState!.validate()) {
                                final data = {
                                  "email": context.read<UserProvider>().userDetails!.email,
                                  "firstName": firstName.text.toString(),
                                  "lastName": lastName.text.toString(),
                                  "state": state,
                                  "phone": phone.text.toString(),
                                  "campus": campus,
                                };
                              context.read<UserProvider>().editProfile(data, context.read<AuthProvider>().accessToken,context);
                            }
                          },
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              padding: const EdgeInsets.all(20),
                              width: size.width,
                              decoration: BoxDecoration(
                                  gradient:  LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.topLeft,
                                    colors: validateEdit() ?  [
                                            primary,
                                            secondary,
                                          ] : [
                                              grey,
                                              grey,
                                            ]
          
                                  ),
                                  color: primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text("Edit Profile",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17))));
                    }),
          
                    Container(
                      height: 30,
                    ),
          
                  ],
                ),
              )),
        ));
  }

  bool validateEdit() {
    UserModel user = context.read<UserProvider>().userDetails!;
    if (firstName.text.toString() == user.firstName &&
        lastName.text.toString() == user.lastName &&
        phone.text.toString() == user.phone &&
        state == user.state && campus == context.read<UserProvider>().userDetails!.campus || campus == null) {
      return false;
    }
    return true;
  }
}

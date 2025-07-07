import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController confirmedPassword = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    password.dispose();
    oldPassword.dispose();
    confirmedPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
        return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              40.height,
          
              const Text("Change Password", style: TextStyle(fontSize:23,fontWeight:FontWeight.bold)),
              Container(height: 10,),
              const Text("Please enter your current and the set a new one", style: TextStyle(fontSize:16)),
          
              Container(height: 30,),
          
              TextFormField(
                obscureText: true,
                enabled: !provider.editingProfile,
                controller: oldPassword,
                decoration: const InputDecoration(
                    hintText: "Your Password"
                ),
                validator: (String? value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
          
              Container(height: 20,),
          
              TextFormField(
                obscureText: true,
                enabled: !provider.editingProfile,
                controller: password,
                decoration: const InputDecoration(
                    hintText: "New Password"
                ),
                validator: (String? value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (password.text.length < 6) {
                    return 'Password is too short';
                  }
                  return null;
                },
              ),
          
              Container(height: 20,),
          
              TextFormField(
                controller: confirmedPassword,
                obscureText: true,
                enabled: !provider.editingProfile,
                decoration: const InputDecoration(
                    hintText: "Confirm Password"
                ),
                validator: (String? value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (confirmedPassword.text.length < 6) {
                    return 'Password is too short';
                  }
                  return null;
                },
              ),
          
          
              const SizedBox(height: 50,),
          
              !provider.editingProfile ? GestureDetector(
                      onTap: (){

                        if(!_formKey.currentState!.validate()){
                          return;
                        }

                        if(password.text.toString() != confirmedPassword.text.toString()){
                          showMessageError("Passwords do not match");
                        }else{
                          Provider.of<UserProvider>(context, listen: false).changePassword({
                            "password": oldPassword.text.toString(),
                            "new_password": confirmedPassword.text.toString(),
                            "id": context.read<UserProvider>().userDetails?.id
                          }, context.read<AuthProvider>().accessToken);
                        }
          
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          padding: const EdgeInsets.all(20),
                          width: size.width,
                          decoration:  BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.topLeft,
                                colors: [
                                  primary,
                                  secondary,
                                ],
                              ),
                              color: primary,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Text("Change Password", textAlign: TextAlign.center, style: TextStyle(color:Colors.white, fontSize:17))
                      ),
                    ): Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        )
              ),
          
              Container(height: 50,),
          
          
            ],
          ),
        )),
      );
  },
),
    );
  }
}

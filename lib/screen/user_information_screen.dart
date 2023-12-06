import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoneauth/model/user_model.dart';
import 'package:phoneauth/provider/auth_provider.dart';
import 'package:phoneauth/screen/custom_buttom.dart';
import 'package:phoneauth/screen/home_screen.dart';
import 'package:phoneauth/utils/utils.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _userInformationScreenState();
}

class _userInformationScreenState extends State<UserInformationScreen> {

  File? image;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    selectImage();
                    },
                  child: image == null
                    ? CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 30,
                      child: Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.white,
                      ),
                    )
                    : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 50,
                    ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      textField(
                          hintText: "John",
                          icon: Icons.account_circle,
                          maxLines: 1,
                          inputType: TextInputType.name,
                          controller: nameController
                      ),
                      textField(
                          hintText: "John@neb.com",
                          icon: Icons.email,
                          maxLines: 1,
                          inputType: TextInputType.emailAddress,
                          controller: emailController
                      ),
                      textField(
                          hintText: "Bio",
                          icon: Icons.edit,
                          maxLines: 2,
                          inputType: TextInputType.name,
                          controller: bioController
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: CustomButtom(
                    text: "Continue",
                    onPressed: () {
                      storeData();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required int maxLines,
    required TextInputType inputType,
    required TextEditingController controller
  }){

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller:  controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.transparent
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple
        ),
      ),
    );
  }

  void storeData() async{
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        profilPic: "",
        createdAt: "",
        phoneNumber: "",
        uid: ""
    );

    if(image != null){
      ap.saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: image!,
          onSuccess: (){
            ap.saveUserDataToSP()
                .then((value) => ap.setSignIn()
                  .then((value) => Navigator
                    .pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => HomeScreen(),), 
                      (route) => false)
                  )
                );
                
          }
      );
    }else{
      showSnackBar(context, "Please upload");
    }

  }
}

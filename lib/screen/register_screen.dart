import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phoneauth/provider/auth_provider.dart';
import 'package:phoneauth/screen/custom_buttom.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country country = Country(
      phoneCode: "226",
      countryCode: "BF",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "bf",
      example: "bf",
      displayName: "bf",
      displayNameNoCountryCode: "BF",
      e164Key: "");

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length
      )
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.shade50
                  ),
                  child: Image.asset(
                    ""
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "Never a better time than now to start.",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  cursorColor: Colors.purple,
                  controller: phoneController,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter phone number",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black12)
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            countryListTheme: CountryListThemeData(
                              bottomSheetHeight: 500
                            ),
                            onSelect: (value) {
                              setState(() {
                                country = value;
                              });
                          },);
                        },
                        child: Text(
                            "${country.flagEmoji} ${country.phoneCode}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),

                        ),
                      ),
                    ),
                    suffix: phoneController.text.length > 6
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green
                            ),
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButtom(text: "Login", onPressed: () {
                    sendPhoneNumber();
                  },),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber(){
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();

    ap.SignInWithPhone(context, "+${country.phoneCode}$phoneNumber");
  }
}

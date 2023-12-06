import 'package:flutter/material.dart';
import 'package:phoneauth/provider/auth_provider.dart';
import 'package:phoneauth/screen/custom_buttom.dart';
import 'package:phoneauth/screen/user_information_screen.dart';
import 'package:phoneauth/utils/utils.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
          ? Center(child: CircularProgressIndicator(color: Colors.purple,),)
          :Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
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
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.purple
                        )
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      )
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                  ),
                  SizedBox(height: 25,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: CustomButtom(
                      text: "Verify",
                      onPressed: () {
                        if(otpCode != null){
                          verifyOtp(context, otpCode!);
                        }else{
                          showSnackBar(context, "Enter 6-Digit code");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserInformationScreen(),));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Dind'nt receive any code?", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38
                  ),),
                  SizedBox(height: 20,),
                  Text("Resend New Code", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple
                  ),),
                ],
              ),
            ),
          )
        ,
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp){
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: (){
          ap.checkExistingUser().then((value) {
            if(value == true){
              
            }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserInformationScreen(),));
          }
          },);
        }
    );
  }
}

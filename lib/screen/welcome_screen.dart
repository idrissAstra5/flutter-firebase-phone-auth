import 'package:flutter/material.dart';
import 'package:phoneauth/provider/auth_provider.dart';
import 'package:phoneauth/screen/custom_buttom.dart';
import 'package:phoneauth/screen/home_screen.dart';
import 'package:phoneauth/screen/register_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("", height: 300),
                SizedBox(height: 20,),
                Text(
                  "Let's get started",
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
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: CustomButtom(
                    onPressed: () {
                      ap.isSignedIn == true
                          ? Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),))
                          : Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                    },
                    text: "Get Started",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/model/user_model.dart';
import 'package:phoneauth/screen/otp_screen.dart';
import 'package:phoneauth/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  AuthProvider(){
    checkSignIn();
  }

  void checkSignIn() async{
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    s.getBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  void SignInWithPhone(BuildContext context, String phoneNumber) async{
    try{
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
            print("verificationCompleted");
          },
          verificationFailed: (error) {
            print("verificationFailed");
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            print("codeSent");
            print("Code ${verificationId}");
            Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId),));
          },
          codeAutoRetrievalTimeout: (verificationId) {

          },
      );
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message.toString());
    }
  }


  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess}) async{

    _isLoading = true;
    notifyListeners();

    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(credential)).user!;

      if(user!= null){
        _uid = user.uid;
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message.toString());
    }
  }


  Future<bool> checkExistingUser() async{
    DocumentSnapshot snapshot =
      await _firebaseFirestore.collection("users").doc(_uid).get();

    if(snapshot.exists){
      print("USER EXISTS");
      return true;
    }
    else{
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess
  }) async{
    _isLoading = true;
    notifyListeners();
    try{
      await storeFileStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilPic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      },);
      _userModel = userModel;
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
            onSuccess();
            _isLoading = false;
            notifyListeners();
      },);
    }on FirebaseAuthException catch(e){
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileStorage(String ref, File file) async{
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future saveUserDataToSP() async{
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }
}
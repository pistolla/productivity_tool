import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remotesurveyadmin/api/resource/user_resource.dart';
import 'package:remotesurveyadmin/api/response.dart';
import 'package:flutter/cupertino.dart';

import 'response_data.dart';

class AuthService extends UserResource {
  // Singleton
  AuthService._privateConstructor();

  static final AuthService _authService = AuthService._privateConstructor();

  factory AuthService() => _authService;

  @override
  Future<ResponseData> newUser(Map<String, dynamic> params) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params["email"],
        password: params["pass0"],
      );
      return ResponseData<Response>.success(const Response(
          status: 0, statusDesc: '', data: {"user": "", "token": ""}));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResponseData<Response>.error(
            "The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        return ResponseData<Response>.error(
            "The account already exists for that email");
      }
      return ResponseData<Response>.error(e.message!);
    } catch (e) {
      return ResponseData<Response>.error("$e");
    }
  }

  @override
  Future<ResponseData> authenticate(Map<String, dynamic> params) async {
    debugPrint("authenticate");
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: params["email"],
        password: params["password"],
      );
      final user = userCredential.user;
      if(user != null && params["phone"].toString().isNotEmpty && params["name"].toString().isNotEmpty){
        user.updatePhoneNumber(params["phone"]);
        user.updateDisplayName(params["name"]);
      }
      return ResponseData<Response>.success(Response(
          status: 0,
          statusDesc: 'Login Successful',
          data: {"user": user?.uid, "token": user?.uid}));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ResponseData<Response>.error("No user found for that email");
      } else if (e.code == 'wrong-password') {
        return ResponseData<Response>.error(
            "Wrong password provided for that user.");
      }
      return ResponseData<Response>.error("Error ${e.message!}");
    } catch (e) {
      return ResponseData<Response>.error("$e");
    }
  }

  @override
  Stream<ResponseData> verifyPhoneNumber(Map<String, dynamic> params) async* {
    debugPrint("send code");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: params["phone"],
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          ResponseData<Response>.success(const Response(
              status: 0,
              statusDesc: 'Phone verification successful',
              data: {}));
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) {},
        codeSent: (String verificationId, int? forceResendingToken) async {
          // Update the UI - wait for the user to enter the SMS code
          String smsCode = 'xxxx';
          ResponseData<Response>.error("check your phone we have sent a code");

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      yield ResponseData<Response>.error("$e");
    }
  }

  Future<ResponseData> forgotPassword(Map<String, dynamic> params) async {
    debugPrint("reset password");
    await FirebaseAuth.instance.sendPasswordResetEmail(email: params["email"]);
    return ResponseData<Response>.success(const Response(
        status: 0, statusDesc: '', data: {"user": "", "token": ""}));
  }

  Future<ResponseData> resetPassword(Map<String, dynamic> params) async {
    debugPrint("reset password");
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        user.updatePassword(params["password"]);
      }
    });
    return ResponseData<Response>.success(const Response(
        status: 0, statusDesc: '', data: {"user": "", "token": ""}));
  }

  @override
  Future<ResponseData> otpPassword(Map<String, dynamic> params) async {
    debugPrint("otp");
    return ResponseData<Response>.error("Api not set up correctly");
  }

  Future<ResponseData<Response>> fetchProfile(
      Map<String, dynamic> params) async {
    debugPrint("fetch profile");
    String uid = "";
    String name = "";
    String emailAddress = "";
    String profilePhoto = "";
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint(user.uid);
      for (final providerProfile in user.providerData) {
        final provider = providerProfile.providerId;
        uid = providerProfile.uid!;
        name = providerProfile.displayName!;
        emailAddress = providerProfile.email!;
        profilePhoto = providerProfile.photoURL!;
      }
    }

    return ResponseData<Response>.success(
         Response(status: 0, statusDesc: '', data: {
      "avatar": profilePhoto,
      "email": emailAddress,
      "firstName": name,
      "lastName": name,
      "names": name,
      "phone": ""
    })); // CREATE RESPONSE
  }

  Future<ResponseData<Response>> updateProfile(
      Map<String, dynamic> params) async {
    debugPrint("update Profile");
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);

        user.updateDisplayName("Jane Q. User");
        user.updatePhotoURL("https://example.com/jane-q-user/profile.jpg");
      }
    });
    return ResponseData<Response>.success(const Response(
        status: 0,
        statusDesc: '',
        data: {"user": "", "token": ""})); // CREATE RESPONSE
  }

  ResponseData<Response> checkUserLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return ResponseData<Response>.success(
          Response(status: 0, statusDesc: '', data: {
        "user": FirebaseAuth.instance.currentUser?.uid,
        "token": FirebaseAuth.instance.currentUser?.uid
      }));
    } else {
      return ResponseData<Response>.error("Api not set up correctly");
    }
  }
}

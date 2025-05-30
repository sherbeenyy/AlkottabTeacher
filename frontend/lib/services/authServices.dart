import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/services/teacher/teacher.dart';
import 'package:frontend/services/teacher/teacherApi.dart';
import 'package:http/http.dart' as http;

import 'teacher/teacherServices.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeacherApi _teacherApi = TeacherApi();
  // Future<AuthResponse> registerTeacher(
  //     {required String email, required String password}) async {
  //   if (email.isEmpty || password.isEmpty) {
  //     return AuthResponse(
  //         success: false, message: "Email and Password are Required");
  //   }
  //   try {
  //     UserCredential credential = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);

  //     await _firestore.collection("teachers").doc(credential.user!.uid).set(
  //         Teacher(email: email, uid: credential.user!.uid).toFirebaseMap());
  //     return AuthResponse(
  //         success: true, message: "Account Registered Successfully!");
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage;
  //     print(e);
  //     if (e.code == 'weak-password') {
  //       errorMessage = 'The password provided is too weak.';
  //     } else if (e.code == 'email-already-in-use') {
  //       errorMessage = 'The account already exists for that email.';
  //     } else {
  //       errorMessage = 'An unknown error occurred.';
  //     }
  //     return AuthResponse(success: false, message: errorMessage);
  //   } on FirebaseException catch (e) {
  //     String errorMessage;
  //     print(e);
  //     if (e.code == 'permission-denied') {
  //       errorMessage = 'You do not have permission to perform this action.';
  //     } else {
  //       errorMessage = 'An unknown Firestore error occurred.';
  //     }
  //     return AuthResponse(success: false, message: errorMessage);
  //   } catch (e) {
  //     print(e);
  //     return AuthResponse(
  //         success: false, message: 'An unknown error occurred.');
  //   }
  // }

  Future<AuthResponse> registerTeacher(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      return AuthResponse(
          success: false, message: "Email and Password are Required");
    }
    try {
      http.Response response =
          await _teacherApi.registerTeacher(email, password);
      TeacherResponse teacherResponse = TeacherResponse.fromJson(
          jsonDecode(response.body), response.statusCode);

      if (teacherResponse.statusCode == 201) {
        try {
          final userCredential = await FirebaseAuth.instance
              .signInWithCustomToken(teacherResponse.customToken!);
          print("Sign-in successful.");

          return AuthResponse(success: true, message: "Sign-in successful.");
        } on FirebaseAuthException catch (e) {
          return AuthResponse(success: true, message: teacherResponse.message);
        }
      } else {
        return AuthResponse(success: false, message: teacherResponse.message);
      }
    } catch (e) {
      print(e);
      return AuthResponse(
          success: false, message: 'An unknown error occurred.');
    }
  }

  Future<AuthResponse> loginTeacher(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      return AuthResponse(
          success: false, message: "Email and password are required");
    }
    try {
      final QuerySnapshot teacherDoc = await _firestore
          .collection("teachers")
          .where('email', isEqualTo: email)
          .get();

      if (teacherDoc.docs.isEmpty) {
        return AuthResponse(
            success: false, message: "No account found for this email.");
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResponse(success: true, message: "Login Successful!");
    } catch (e) {
      return AuthResponse(success: false, message: "Failed to login!");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthResponse {
  final bool success;
  final String message;

  AuthResponse({required this.success, required this.message});
}

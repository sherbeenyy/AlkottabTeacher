import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/services/teacher/teacherApi.dart';
import 'package:frontend/services/teacher/teacherApiSchema.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'teacher.dart';

class Teacherservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeacherApi _teacherApi = TeacherApi();

  Future<TeacherSnackBar> editTeacher(EditTeacherRequest request) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Convert the Teacher object to a map
        http.Response response = await _teacherApi.editTeacher(request);

        TeacherResponse teacherResponse = TeacherResponse.fromJson(
            jsonDecode(response.body), response.statusCode);

        if (teacherResponse.statusCode == 200) {
          return TeacherSnackBar(
              success: true, message: teacherResponse.message);
        } else if (teacherResponse.statusCode == 404) {
          return TeacherSnackBar(
              success: false, message: teacherResponse.message);
        } else if (teacherResponse.statusCode == 500) {
          return TeacherSnackBar(
              success: false, message: teacherResponse.message);
        } else {
          return TeacherSnackBar(
              success: false, message: teacherResponse.message);
        }
      } else {
        return TeacherSnackBar(
            success: false,
            message: 'User is not logged in or UID does not match');
      }
    } catch (e) {
      print('Error updating teacher data: $e');
      return TeacherSnackBar(
          success: false, message: 'Error updating teacher data: $e');
    }
  }

  Future<Teacher?> getCurrentTeacher() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetched the teacher document from Firestore using the user's UID

        http.Response response = await _teacherApi.getCurrentTeacher(user.uid);

        TeacherResponse teacherResponse = TeacherResponse.fromJson(
            jsonDecode(response.body), response.statusCode);

        if (teacherResponse.teacher != null) {
          // Convert the Firestore document to a Teacher object
          return Teacher.fromFirebaseMap(
            teacherResponse.teacher as Map<String, dynamic>,
            uid: user.uid, // Pass the uid explicitly
          );
        } else if (teacherResponse.statusCode == 404) {
          print('Teacher document does not exist');
          return null;
        }
      } else {
        print('No user is currently logged in');
        return null;
      }
    } catch (e) {
      print('Error fetching current teacher data: $e');
      return null;
    }
    return null;
  }
}

class TeacherResponse {
  final int statusCode;
  final String message;
  final String? details;
  final Map<String, dynamic>? teacher;
  final List<Map<String, dynamic>>? teacherList;
  final String? customToken;

  TeacherResponse({
    required this.statusCode,
    required this.message,
    this.details,
    this.teacher,
    this.teacherList,
    this.customToken,
  });

  factory TeacherResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    return TeacherResponse(
      statusCode: statusCode,
      message: json['message'],
      details: json['details'],
      teacher: json['teacher'],
      teacherList: json['teacherList'],
      customToken: json['customToken'],
    );
  }
}

class TeacherSnackBar {
  final bool success;
  final String message;

  TeacherSnackBar({required this.success, required this.message});
}

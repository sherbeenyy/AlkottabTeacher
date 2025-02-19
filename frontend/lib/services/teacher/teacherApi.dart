import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class TeacherApi {
  Future<String?> getIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? token = await user.getIdToken();
      return token;
    }
    return null;
  }

  Future<http.Response> editTeacher(
      Map<String, dynamic> teacherMap, String uid) async {
    String? token = await getIdToken(); // Await the future
    return http.put(
      Uri.parse('http://10.0.2.2:8080/api/teacher/editTeacher/$uid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(teacherMap),
    );
  }

  Future<http.Response> getCurrentTeacher(String uid) async {
    String? token = await getIdToken(); // Await the future
    return http.get(
      Uri.parse('http://10.0.2.2:8080/api/teacher/getCurrentTeacher'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }
}

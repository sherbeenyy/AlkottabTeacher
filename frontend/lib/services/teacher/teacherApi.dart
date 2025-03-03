import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/services/teacher/teacherApiSchema.dart';
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

  Future<http.Response> editTeacher(EditTeacherRequest request) async {
    String? token = await getIdToken(); // Await the future
    return http.put(
      Uri.parse('http://10.0.2.2:8080/api/teacher/editTeacher'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toMap()),
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

  Future<http.Response> registerTeacher(String email, String password) async {
    return http.post(
      Uri.parse('http://10.0.2.2:8080/api/teacher/registerTeacher'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }
}

import 'package:frontend/services/teacher/teacher.dart';

class EditTeacherRequest {
  final String firstName;
  final String lastName;
  final int birthYear;
  final int birthMonth;
  final int birthDay;
  final String phoneNumber;
  final String description;
  final Nationality nationality; //convert enums to indexes
  final Gender gender;
  final Level preferredStudentLevel;
  final AgeRange preferredStudentAgeRange;
  final List<Qiraah> qiraah;

  EditTeacherRequest({
    required this.firstName,
    required this.lastName,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.phoneNumber,
    required this.description,
    required this.nationality,
    required this.gender,
    required this.preferredStudentLevel,
    required this.preferredStudentAgeRange,
    required this.qiraah,
  });
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthYear': birthYear,
      'birthMonth': birthMonth,
      'birthDay': birthDay,
      'phoneNumber': phoneNumber,
      'description': description,
      'nationality': nationality.index,
      'gender': gender.index,
      'preferredStudentLevel': preferredStudentLevel.index,
      'preferredStudentAgeRange': preferredStudentAgeRange.index,
      'qiraah': qiraah.map((q) => q.index).toList(),
    };
  }
}

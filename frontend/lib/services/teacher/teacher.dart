class Teacher {
  final String email;
  final String uid;
  String? firstName;
  String? lastName;

  Teacher(
      {required this.email, required this.uid, this.firstName, this.lastName});

  Map<String, dynamic> toFirebaseMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  static Teacher fromFirebaseMapToArabic(Map<String, dynamic> map,
      {required String uid}) {
    return Teacher(
      email: map['email'],
      uid: uid,
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }
}

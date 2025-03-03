class Teacher {
  final String email;
  final String uid;

  String? firstName;
  String? lastName;
  String? birthYear;
  String? birthMonth;
  String? birthDay;
  String? phoneNumber;
  String? description;
  Nationality? nationality;
  Gender? gender;
  AgeRange? preferredStudentAgeRange;
  Level? preferredStudentLevel;
  List<Qiraah> qiraah; // Changed to a list of Qiraah
  final int rating; // Added rating attribute

  Teacher({
    required this.email,
    required this.uid,
    this.firstName,
    this.lastName,
    this.birthYear,
    this.birthMonth,
    this.birthDay,
    this.phoneNumber,
    this.description,
    this.nationality,
    this.gender,
    this.preferredStudentAgeRange,
    this.preferredStudentLevel,
    this.qiraah = const [], // Default to an empty list
    required this.rating, // Rating is required
  });

  Map<String, dynamic> toFirebaseMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthYear': birthYear,
      'birthMonth': birthMonth,
      'birthDay': birthDay,
      'phoneNumber': phoneNumber,
      'description': description,
      'nationality': nationality?.index,
      'gender': gender?.index,
      'preferredStudentAgeRange': preferredStudentAgeRange?.index,
      'preferredStudentLevel': preferredStudentLevel?.index,
      'qiraah': qiraah
          .map((q) => q.index)
          .toList(), // Convert list of Qiraah to list of indices
      'rating': rating, // Add rating to map
    };
  }

  static Teacher fromFirebaseMap(Map<String, dynamic> map,
      {required String uid}) {
    return Teacher(
      email: map['email'],
      uid: uid,
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthYear: map['birthYear'],
      birthMonth: map['birthMonth'],
      birthDay: map['birthDay'],
      phoneNumber: map['phoneNumber'],
      description: map['description'],
      nationality: _getNationalityFromIndex(map['nationality']),
      gender: _getGenderFromIndex(map['gender']),
      preferredStudentAgeRange:
          _getAgeRangeFromIndex(map['preferredStudentAgeRange']),
      preferredStudentLevel: _getLevelFromIndex(map['preferredStudentLevel']),
      qiraah: _getQiraahListFromIndices(
          map['qiraah']), // Convert list of indices to list of Qiraah
      rating: map['rating'], // Add rating from map
    );
  }

  static AgeRange? _getAgeRangeFromIndex(int? index) {
    if (index == null) return null;
    return AgeRange.values[index];
  }

  static Gender? _getGenderFromIndex(int? index) {
    if (index == null) return null;
    return Gender.values[index];
  }

  static Nationality? _getNationalityFromIndex(int? index) {
    if (index == null) return null;
    return Nationality.values[index];
  }

  static Level? _getLevelFromIndex(int? index) {
    if (index == null) return null;
    return Level.values[index];
  }

  static List<Qiraah> _getQiraahListFromIndices(List<dynamic>? indices) {
    if (indices == null) return [];
    return indices.map((index) => Qiraah.values[index]).toList();
  }

  // Maps for translating enum values to Arabic and English
  static const Map<AgeRange, String> ageRangeToArabic = {
    AgeRange.age13_17: '13-17',
    AgeRange.age18_25: '18-25',
    AgeRange.age26_35: '26-35',
    AgeRange.age36_45: '36-45',
    AgeRange.age46_55: '46-55',
    AgeRange.age56_65: '56-65',
    AgeRange.age66Plus: '66+',
  };

  static const Map<AgeRange, String> ageRangeToEnglish = {
    AgeRange.age13_17: '13-17',
    AgeRange.age18_25: '18-25',
    AgeRange.age26_35: '26-35',
    AgeRange.age36_45: '36-45',
    AgeRange.age46_55: '46-55',
    AgeRange.age56_65: '56-65',
    AgeRange.age66Plus: '66+',
  };

  static const Map<Gender, String> genderToArabic = {
    Gender.male: 'ذكر',
    Gender.female: 'أنثى',
  };

  static const Map<Gender, String> genderToEnglish = {
    Gender.male: 'Male',
    Gender.female: 'Female',
  };

  static const Map<Nationality, String> nationalityToArabic = {
    Nationality.A: 'الجنسية أ',
    Nationality.B: 'الجنسية ب',
    Nationality.C: 'الجنسية ج',
    Nationality.D: 'الجنسية د',
  };

  static const Map<Nationality, String> nationalityToEnglish = {
    Nationality.A: 'Nationality A',
    Nationality.B: 'Nationality B',
    Nationality.C: 'Nationality C',
    Nationality.D: 'Nationality D',
  };

  static const Map<Level, String> levelToArabic = {
    Level.beginner: 'مبتدئ',
    Level.intermediate: 'متوسط',
    Level.advanced: 'متقدم',
  };

  static const Map<Level, String> levelToEnglish = {
    Level.beginner: 'Beginner',
    Level.intermediate: 'Intermediate',
    Level.advanced: 'Advanced',
  };

  static const Map<Qiraah, String> qiraahToArabic = {
    Qiraah.qiraah1: 'قراءة 1',
    Qiraah.qiraah2: 'قراءة 2',
    Qiraah.qiraah3: 'قراءة 3',
    Qiraah.qiraah4: 'قراءة 4',
  };

  static const Map<Qiraah, String> qiraahToEnglish = {
    Qiraah.qiraah1: 'Qiraah 1',
    Qiraah.qiraah2: 'Qiraah 2',
    Qiraah.qiraah3: 'Qiraah 3',
    Qiraah.qiraah4: 'Qiraah 4',
  };
}

// Enums
enum Level { beginner, intermediate, advanced }

enum AgeRange {
  age13_17,
  age18_25,
  age26_35,
  age36_45,
  age46_55,
  age56_65,
  age66Plus
}

enum Nationality { A, B, C, D }

enum Gender { male, female }

enum Qiraah { qiraah1, qiraah2, qiraah3, qiraah4 }

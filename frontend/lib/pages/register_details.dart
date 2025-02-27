import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/teacher/teacher.dart';
import 'package:frontend/services/teacher/teacherServices.dart';
import 'package:frontend/widgets/snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_page.dart';

class RegisterDetails extends StatefulWidget {
  const RegisterDetails({super.key});

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final bioController = TextEditingController();

  // Default selections
  AgeRange selectedAge = AgeRange.age13_17;
  Nationality selectedCountry = Nationality.A;
  Level selectedStudentLevel = Level.beginner;
  Gender selectedGender = Gender.male;
  List<Qiraah> selectedQera2at = [];

  // For profile picture and files
  File? _profileImage;
  File? _bachelorDegreeFile;
  File? _ejazaFile;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to pick a PDF file
  Future<void> _pickPDF(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == 'bachelor') {
          _bachelorDegreeFile = File(pickedFile.path);
        } else if (type == 'ejaza') {
          _ejazaFile = File(pickedFile.path);
        }
      });
    }
  }

  final Teacherservices teacherservices = Teacherservices();
  bool isLoading = false;
  // Handle teacher edit logic
  void handleTeacherEdit() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showSnackBar(context, 'لم يتم العثور على مستخدم مسجل', false);
      return;
    }

    // Create a Teacher object
    EditTeacherRequest request = EditTeacherRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        birthYear: int.parse(yearController.text),
        birthMonth: int.parse(monthController.text),
        birthDay: int.parse(dayController.text),
        phoneNumber: phoneController.text,
        description: bioController.text,
        nationality: selectedCountry,
        gender: selectedGender,
        preferredStudentLevel: selectedStudentLevel,
        preferredStudentAgeRange: selectedAge,
        qiraah: selectedQera2at);
    // Print or upload the teacher object
    TeacherSnackBar response = await teacherservices.editTeacher(teacher);
    if (response.success) {
      setState(() {
        isLoading = true;
      });
      showSnackBar(context, response.message, response.success);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, response.message, response.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل حساب معلم جديد'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Circular profile picture with file picker
                Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt,
                                size: 50, color: Colors.black54)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'صورة الملف الشخصي',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // First Name
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: firstNameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'الاسم الأول',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الأول';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Last Name
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: lastNameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'الاسم الأخير',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الأخير';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Date of Birth (Day, Month, Year)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تاريخ الميلاد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dayController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            labelText: 'يوم',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اليوم';
                            }
                            final day = int.tryParse(value);
                            if (day == null || day < 1 || day > 31) {
                              return 'يوم غير صالح';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: monthController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            labelText: 'شهر',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الشهر';
                            }
                            final month = int.tryParse(value);
                            if (month == null || month < 1 || month > 12) {
                              return 'شهر غير صالح';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: yearController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            labelText: 'سنة',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال السنة';
                            }
                            final year = int.tryParse(value);
                            if (year == null ||
                                year < 1900 ||
                                year > DateTime.now().year) {
                              return 'سنة غير صالحة';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Gender Radio Buttons
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الجنس',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio<Gender>(
                            value: Gender.male,
                            groupValue: selectedGender,
                            onChanged: (Gender? value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          const Text('ذكر',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Radio<Gender>(
                            value: Gender.female,
                            groupValue: selectedGender,
                            onChanged: (Gender? value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          const Text('أنثى',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Country Dropdown
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<Nationality>(
                    value: selectedCountry,
                    items: Nationality.values.map((Nationality country) {
                      return DropdownMenuItem<Nationality>(
                        value: country,
                        child: Text(Teacher.nationalityToArabic[country]!),
                      );
                    }).toList(),
                    onChanged: (Nationality? value) {
                      setState(() {
                        selectedCountry = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'البلد',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.flag),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: phoneController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Bachelor Degree PDF Upload
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رفع شهادة البكالوريوس (صورة)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _pickPDF('bachelor'),
                          child: const Text('اختر ملف'),
                        ),
                      ),
                      if (_bachelorDegreeFile != null)
                        Center(
                          child: Text(
                            'تم اختيار الملف: ${_bachelorDegreeFile!.path.split('/').last}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Ejaza PDF Upload
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رفع الإجازة (صورة)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _pickPDF('ejaza'),
                          child: const Text('اختر ملف'),
                        ),
                      ),
                      if (_ejazaFile != null)
                        Center(
                          child: Text(
                            'تم اختيار الملف: ${_ejazaFile!.path.split('/').last}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Preferred Student Level
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المستوى المفضل للطلاب',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Level>(
                        value: selectedStudentLevel,
                        items: Level.values.map((Level level) {
                          return DropdownMenuItem<Level>(
                            value: level,
                            child: Text(Teacher.levelToArabic[level]!),
                          );
                        }).toList(),
                        onChanged: (Level? value) {
                          setState(() {
                            selectedStudentLevel = value!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Preferred Qera2at
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'القراءات المفضلة',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: Qiraah.values.map((Qiraah qiraah) {
                          return CheckboxListTile(
                            value: selectedQera2at.contains(qiraah),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedQera2at.add(qiraah);
                                } else {
                                  selectedQera2at.remove(qiraah);
                                }
                              });
                            },
                            title: Text(Teacher.qiraahToArabic[qiraah]!),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bio Text Area
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: bioController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'السيرة الذاتية',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال السيرة الذاتية';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleTeacherEdit();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'تسجيل',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

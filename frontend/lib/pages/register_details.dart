import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';
import 'dart:io';

class RegisterDetails extends StatefulWidget {
  const RegisterDetails({super.key});

  @override
  State<RegisterDetails> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  // List of countries (sorted in ascending order)
  final List<String> countries = ['مصر', 'السعودية', 'الإمارات', 'الكويت', 'قطر', 'البحرين', 'عمان'];

  // List of age options (starting from 23)
  final List<String> ages = List.generate(78, (index) => (index + 23).toString());

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

  String selectedAge = '';
  String selectedCountry = '';

  // Gender selection
  String selectedGender = 'male'; // Default gender

  // For profile picture
  File? _profileImage;

  // For PDF files
  File? _bachelorDegreeFile;
  File? _ejazaFile;

  // For preferred student level (now using checkboxes)
  final List<String> _studentLevelOptions = ['مبتدئ', 'متوسط', 'خبير'];
  final List<bool> _selectedStudentLevels = [false, false, false];

  // For preferred qera2at
  final List<String> _qera2atOptions = List.generate(20, (index) => 'قراءة ${index + 1}');
  final List<bool> _selectedQera2at = List.generate(20, (index) => false);

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

  @override
  void initState() {
    super.initState();
    selectedAge = ages[0]; // Initialize in initState
    selectedCountry = countries[0]; // Initialize in initState
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
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 50, color: Colors.black54)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'صورة الملف الشخصي',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            if (year == null || year < 1900 || year > DateTime.now().year) {
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'male',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          const Text('ذكر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Radio(
                            value: 'female',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                          const Text('أنثى', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Country Dropdown
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    value: selectedCountry,
                    items: countries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (value) {
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

                // Preferred Student Level (now using checkboxes)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المستوى المفضل للطلاب',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: List.generate(
                          _studentLevelOptions.length,
                          (index) => CheckboxListTile(
                            value: _selectedStudentLevels[index],
                            onChanged: (value) {
                              setState(() {
                                _selectedStudentLevels[index] = value!;
                              });
                            },
                            title: Text(_studentLevelOptions[index]),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: List.generate(
                          _qera2atOptions.length,
                          (index) => CheckboxListTile(
                            value: _selectedQera2at[index],
                            onChanged: (value) {
                              setState(() {
                                _selectedQera2at[index] = value!;
                              });
                            },
                            title: Text(_qera2atOptions[index]),
                          ),
                        ),
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
                        // Handle form submission
                        print('تم تسجيل النموذج بنجاح');
                        print('الاسم الأول: ${firstNameController.text}');
                        print('الاسم الأخير: ${lastNameController.text}');
                        print('العمر: $selectedAge');
                        print('البلد: $selectedCountry');
                        print('رقم الهاتف: ${phoneController.text}');
                        print('الجنس: $selectedGender');
                        if (_profileImage != null) {
                          print('تم اختيار صورة: ${_profileImage!.path}');
                        }
                        if (_bachelorDegreeFile != null) {
                          print('تم اختيار ملف البكالوريوس: ${_bachelorDegreeFile!.path}');
                        }
                        if (_ejazaFile != null) {
                          print('تم اختيار ملف الإجازة: ${_ejazaFile!.path}');
                        }
                        print('المستوى المفضل للطلاب: ${_studentLevelOptions.where((element) => _selectedStudentLevels[_studentLevelOptions.indexOf(element)]).toList()}');
                        print('القراءات المفضلة: ${_qera2atOptions.where((element) => _selectedQera2at[_qera2atOptions.indexOf(element)]).toList()}');
                        print('السيرة الذاتية: ${bioController.text}');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                    
                      
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
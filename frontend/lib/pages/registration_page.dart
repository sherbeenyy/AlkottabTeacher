import 'package:frontend/services/authServices.dart';
import 'package:frontend/widgets/snack_bar.dart';

import "register_details.dart";
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();

  bool isLoading = false;

  void handleRegister() async {
    String email = emailController.text;
    String password = passwordController.text;

    AuthResponse response =
        await AuthServices().registerTeacher(email: email, password: password);
    if (response.success) {
      setState(() {
        isLoading = true;
      });
      showSnackBar(context, response.message, response.success);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => RegisterDetails()));
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('إنشاء حساب للمعلم'),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'إنشاء حساب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'الحساب الإلكتروني',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الحساب الإلكتروني';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'الرجاء إدخال حساب إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: passwordController,
                    textAlign: TextAlign.right,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة السر',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة السر';
                      }
                      if (value.length < 8) {
                        return 'كلمة السر يجب أن تكون أكثر من 8 أحرف';
                      }
                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                          .hasMatch(value)) {
                        return 'كلمة السر يجب أن تحتوي على حرف صغير وحرف كبير ورقم';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    textAlign: TextAlign.right,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة السر',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال تأكيد كلمة السر';
                      }
                      if (value != passwordController.text) {
                        return 'كلمة السر وتأكيد كلمة السر يجب أن تكون متماثلة';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0, top: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          handleRegister();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'التالي',
                        style: TextStyle(fontSize: 18),
                      ),
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

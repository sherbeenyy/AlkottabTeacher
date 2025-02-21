import 'package:flutter/material.dart';
import 'package:frontend/services/authServices.dart';
import 'package:frontend/services/teacher/teacher.dart';
import 'login_page.dart';
import 'edit_profile.dart';
import '../services/teacher/teacherServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Teacher? _currentTeacher;


    @override
  void initState() {
    super.initState();
    _fetchCurrentTeacher();
  }

  Future<void> _fetchCurrentTeacher() async {
    Teacherservices teacherServices = Teacherservices();
    Teacher? teacher = await teacherServices.getCurrentTeacher();
    if (teacher != null) {
          setState(() {
      _currentTeacher = teacher;
    });
    }

  }
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('reservations Page'),
    Text('my timetable Page'),
    Text('Chat Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: Text(_currentTeacher != null
            ? "مرحبا ${_currentTeacher!.firstName}"
            : "not found"),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                          './assets/img/teacher.png'), 
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile()));
                      },
                      child: Text(
                        'تعديل الحساب',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text('الرصيد'),
                ),
                onTap: () {
                  // Handle Balance tap
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text('الإعدادات'),
                ),
                onTap: () {
                  // Handle Settings tap
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text('عن التطبيق'),
                ),
                onTap: () {
                  // Handle About App tap
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text('تسجيل الخروج'),
                ),
                onTap: () async {
                  await AuthServices().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'الحجوزات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'جدولي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'الدردشة',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
    );
  }
}

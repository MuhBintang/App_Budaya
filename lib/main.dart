import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uas_budaya/budaya/budaya_screen.dart';
import 'package:uas_budaya/home_page/home_screen.dart';
import 'package:uas_budaya/login_reg_page/splash_screen.dart';
import 'package:uas_budaya/profile/profile_screen.dart';
import 'package:uas_budaya/tiket/list_favorite_screen.dart';
import 'package:uas_budaya/tiket/list_tiket.dart';
import 'package:uas_budaya/tiket/notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Kebudayaan',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, 
            foregroundColor: Colors.white
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22), 
          backgroundColor: Color(0xffF4B5A4), 
          iconTheme: IconThemeData(color: Colors.white)
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class BottomNavBar extends StatefulWidget {
  final int initialIndex; // Tambahkan initialIndex
  const BottomNavBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Widget> body = const [
    Icon(Icons.home_filled),
    Icon(Icons.architecture_outlined),
    Icon(Icons.card_membership_outlined),
    Icon(Icons.person_2),
  ];

  final screen = [
    const HomeScreen(),
    const ListBudaya(),
    const ListTiket(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget
        .initialIndex; // Atur _currentIndex dengan initialIndex dari widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.architecture_outlined), label: "Budaya"),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_membership_outlined), label: "List Tiket"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
        backgroundColor:
            Colors.white, // Warna latar belakang BottomNavigationBar
        selectedItemColor: Color(0xffF4B5A4), // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        type: BottomNavigationBarType.fixed, // Jenis BottomNavigationBar
      ),
    );
  }
}

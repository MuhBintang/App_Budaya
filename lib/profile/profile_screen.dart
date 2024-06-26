import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/login_reg_page/forgot_password_screen.dart';
import 'package:uas_budaya/login_reg_page/login_screen.dart';
import 'package:uas_budaya/profile/detail_profil_screen.dart';
import 'package:uas_budaya/profile/legal_screen.dart';
import 'package:uas_budaya/profile/notification_screen.dart';
import 'package:uas_budaya/profile/profile_edit_screen.dart';
import 'package:uas_budaya/tiket/list_favorite_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? id, username, email, address;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id");
      username = pref.getString("username");
      email = pref.getString("email");
      address = pref.getString("address");
    });
  }

  Future<void> saveSession(String username, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("username", username);
    pref.setString("id", id);
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear(); // Clear all stored preferences
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Remove all routes in the stack
    );
  }

  void showLogoutConfirmation() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFAF0E6), // #FAF0E6
                      onPrimary: Color(0xFFDCBEB6), // #DCBEB6
                      minimumSize: Size(170, 50), // Width 170, Height 50
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Border radius 5
                      ),
                    ),
                    child: Text('Cancel', style: TextStyle(color: Color(0xFFDCBEB6))), // #DCBEB6
                  ),
                  ElevatedButton(
                    onPressed: () {
                      logout(); // Perform logout action
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF4B5A4), // #F4B5A4
                      onPrimary: Color(0xFFCC7861), // #CC7861
                      minimumSize: Size(170, 50), // Width 170, Height 50
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Border radius 5
                      ),
                    ),
                    child: Text('Logout', style: TextStyle(color: Color(0xFFCC7861))), // #CC7861                  
                  ),SizedBox(height: 150,)
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  'My Profile',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      '$username',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'ID: $id',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildProfileOption(Icons.person, 'Edit Profile', () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PageEditProfile(),
                )).then((result) {
                  if (result != null) {
                    setState(() {
                      username = result;
                    });
                  }
                });
              }),
              buildProfileOption(Icons.info, 'Info User', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailProfilScreen()));
              }),
              buildProfileOption(Icons.lock, 'Change Password', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
              }),
              buildProfileOption(Icons.favorite, 'My Favorite', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListFavoriteScreen()));
              }),
              buildProfileOption(Icons.notifications, 'Notification', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationScreen()));
              }),
              buildProfileOption(Icons.policy, 'Legal And Policies', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PageLegal()));
              }),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showLogoutConfirmation(); // Show logout confirmation bottom sheet
                  },
                  icon: Icon(Icons.logout, color: Colors.orangeAccent),
                  label: Text(
                    'Logout',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    side: BorderSide(color: Colors.orangeAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

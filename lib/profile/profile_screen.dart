import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/login_reg_page/forgot_password_screen.dart';
import 'package:uas_budaya/login_reg_page/login_screen.dart';
import 'package:uas_budaya/profile/legal_screen.dart';
import 'package:uas_budaya/profile/profile_edit_screen.dart';

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
      email = pref.getString("address");
      address = pref.getString("email");
    });
  }

  Future<void> saveSession(String username, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("username", username);
    pref.setString("id", id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  builder: (context) => EditProfileScreen(),
                )).then((result) {
                  if (result != null) {
                    setState(() {
                      username = result;
                    });
                  }
                });
              }),
              buildProfileOption(Icons.lock, 'Change Password', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
              }),
              buildProfileOption(Icons.notifications, 'Notification', () {
                // Add your notification navigation here
              }),
              buildProfileOption(Icons.policy, 'Legal And Policies', () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PageLegal()));
              }),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    
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

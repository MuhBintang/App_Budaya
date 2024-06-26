import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProfilScreen extends StatefulWidget {
  const DetailProfilScreen({super.key});

  @override
  State<DetailProfilScreen> createState() => _DetailProfilScreenState();
}

class _DetailProfilScreenState extends State<DetailProfilScreen> {
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

  Widget buildProfileOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Profile Detail',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFFF4B5A4), // Warna teks #F4B5A4
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40), // Spacer
                ],
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/profile.png'),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileOption(Icons.info, '$username', () {}),
                  buildProfileOption(Icons.email, '$email', () {}),
                  buildProfileOption(Icons.location_on, '$address', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

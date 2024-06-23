import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_budaya/models/model_edit.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/utils/cek_session.dart';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = false;
  String? id;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> sessionData = await session.getSession();
    setState(() {
      id = sessionData['id'];
      _usernameController.text = sessionData['username'] ?? '';
      _emailController.text = sessionData['email'] ?? '';
      _addressController.text = sessionData['address'] ?? '';
    });
  }

  Future<ModelEditProfile?> updateProfile({
    String? newUsername,
    String? newEmail,
    String? newAddress,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });

      Map<String, String> requestBody = {
        "id": id!,
      };

      if (newUsername != null) {
        requestBody["username"] = newUsername;
      }

      if (newEmail != null) {
        requestBody["email"] = newEmail;
      }

      if (newAddress != null) {
        requestBody["address"] = newAddress;
      }

      final response = await http.post(
        Uri.parse('$url/editprofile.php'),
        body: requestBody,
      );

      ModelEditProfile data = modelEditProfileFromJson(response.body);

      if (data.isSuccess) {
        await session.updateUsername(newUsername ?? '');
        await session.updateEmail(newEmail ?? '');
        await session.updateAddress(newAddress ?? '');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data.message}'),
        ));
        Navigator.pop(context, _usernameController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${data.message}'),
        ));
      }

      return data;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: Color(0xFFF4B5A4)),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'images/profile.png'), // Replace with user's avatar image
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 260),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(height: 50), // Spacer for the loading indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Discard',
                        style: TextStyle(color: Color(0xFFDCBEB6)),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFAF0E6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await updateProfile(
                          newUsername: _usernameController.text,
                          newEmail: _emailController.text,
                          newAddress: _addressController.text,
                        );
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Color(0xFFCC7861)),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF4B5A4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

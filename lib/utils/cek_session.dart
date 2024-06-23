import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  Future<void> saveSession(
      int val, String id, String userName, String email, String address) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("value", val);
    await pref.setString("id", id);
    await pref.setString("username", userName);
    await pref.setString("email", email);
    await pref.setString("address", address);
  }

  Future<Map<String, dynamic>> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? value = pref.getInt("value");
    String? id = pref.getString("id");
    String? username = pref.getString("username");
    String? email = pref.getString("email");
    String? address = pref.getString("address");

    return {
      "value": value,
      "id": id,
      "username": username,
      "email": email,
      "address": address,
    };
  }

  Future<String?> getSesiIdUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? idUser = pref.getString("id");
    return idUser;
  }

  Future<void> updateUsername(String newUsername) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("username", newUsername);
  }

  Future<void> updateEmail(String newEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", newEmail);
  }

  Future<void> updateAddress(String newAddress) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("address", newAddress);
  }

  // Clear session (logout)
  Future<void> clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

// Instance of SessionManager to use throughout the application
SessionManager session = SessionManager();

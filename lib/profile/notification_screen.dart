import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isPaymentEnabled = false;
  bool isCompletedOrderEnabled = false;
  bool isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            color: Color(0xffF4B5A4),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSwitchTile('payment', isPaymentEnabled, (value) {
              setState(() {
                isPaymentEnabled = value;
              });
            }),
            buildSwitchTile('completed order', isCompletedOrderEnabled, (value) {
              setState(() {
                isCompletedOrderEnabled = value;
              });
            }),
            buildSwitchTile('notification', isNotificationEnabled, (value) {
              setState(() {
                isNotificationEnabled = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF4B5A4)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xfffff),
          activeTrackColor: Color(0xffF4B5A4),
        ),
      ),
    );
  }
}

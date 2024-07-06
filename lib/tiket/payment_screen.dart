import 'package:flutter/material.dart';
import 'package:midtrans_snap/midtrans_snap.dart';
import 'package:midtrans_snap/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/tiket/notification.dart';
import 'package:uas_budaya/tiket/success_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PaymentDetailScreen extends StatefulWidget {
  final String snapToken;
  final int orderId;
  const PaymentDetailScreen(
      {Key? key, required this.snapToken, required this.orderId})
      : super(key: key);

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  bool isLoading = false;
  String? id, username;
  int? orderid;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
    });
  }

  Future getOrder() async {
    setState(() {
      orderid = widget.orderId;
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MidtransSnap(
        mode: MidtransEnvironment.sandbox,
        token: widget.snapToken,
        midtransClientKey: 'SB-Mid-client-Xf3wAQGsQv5tn35y',
        onPageFinished: (url) {
          print(url);
        },
        onPageStarted: (url) {
          print(url);
        },
        onResponse: (result) async {
          print(result.toJson());

          // Show notification on response
          await Noti.showBigTextNotification(
            title: 'Transaksi Berhasil',
            body: 'Transaksi Telah Berhasil Dilakukan',
            fln: flutterLocalNotificationsPlugin,
          );

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SuccessPage(orderid)),
              (route) => false);
        },
      ),
    );
  }
}

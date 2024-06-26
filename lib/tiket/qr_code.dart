import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRView extends StatelessWidget {
  final int orderId; // Tambahkan deklarasi orderId di sini

  QRView({required this.orderId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Scan Your Ticket Here",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFF4B5A4),
              fontSize: 20,
            ),
          ),
          Center(
            child: QrImageView(
              data: orderId.toString(), // Gunakan orderId di sini
              version: QrVersions.auto,
              size: 240,
            ),
          ),
        ],
      ),
    );
  }
}

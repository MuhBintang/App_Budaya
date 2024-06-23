import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/models/model_listtiket.dart';

import '../const.dart';
import 'payment_detail.dart';

class CheckoutScreen extends StatefulWidget {
  final Datum ticket;
  final int quantity;
  final int total;

  const CheckoutScreen({
    Key? key,
    required this.ticket,
    required this.quantity,
    required this.total,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? address, username, email, id;
  bool isLoading = false;
  String? snap;

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("email");
      address = pref.getString("address");
      username = pref.getString("username");
      id = pref.getString("id");
    });
  }

  Future<void> placeOrder() async {
  try {
    setState(() {
      isLoading = true;
    });

    var jsonData = jsonEncode({
      'user_id': id,
      'items': [
        {
          'id': widget.ticket.id,
          'ticket_name': widget.ticket.ticketName,
          'ticket_price':
              int.parse(widget.ticket.ticketPrice), // Ensure it's an integer
          'quantity': widget.quantity, // Ensure it's an integer
        }
      ],
      'customer_address': address,
      'total_price': widget.total, // Ensure it's an integer
    });

    final response = await http.post(
      Uri.parse('$url/api.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    print(response.body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['snap_token'] != null &&
          responseData['order_id'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentDetail(
              snapToken: responseData['snap_token'],
              orderId: responseData['order_id'],
            ),
          ),
        );
      } else {
        _showErrorDialog('Failed to place order. Incomplete response.');
        _showSnackBar(toString());
      }
    } else {
      _showErrorDialog('Failed to place order. Server error.');
      _showSnackBar('Failed to place order. Server error.');
    }
  } catch (e) {
    _showErrorDialog('Failed to place order. ${e.toString()}');
    _showSnackBar('Failed to place order. ${e.toString()}');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatCurrency(int amount) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? 'House',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email ?? 'No address found',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Product List Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Ticket',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                Datum ticket = widget.ticket;
                return ListTile(
                  leading: SizedBox(
                    width: 57,
                    height: 57,
                    child: Image.network(
                      '$url/tiket/${ticket.ticketImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(ticket.ticketName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatCurrency(int.parse(ticket.ticketPrice)),
                      ),
                      Text(
                          'Amount : ${widget.quantity}'), // Display the quantity
                    ],
                  ),
                );
              },
            ),
          ),
          // Payment Method Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.payment, size: 40),
            title: Text('Credit/Debit Card'),
            subtitle: Text(address ?? 'user****@gmail.com'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Payment method logic
            },
          ),
          // Total Amount Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              formatCurrency(widget.total),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Checkout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  placeOrder();
                },
                child: Text(
                  'Checkout Now',
                  style: TextStyle(color: Color(0xffCC7861)),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffF4B5A4),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

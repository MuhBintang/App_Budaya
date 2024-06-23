import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_listtiket.dart';
import 'checkout_screen.dart'; // Import the CheckoutScreen

class DetailTiket extends StatefulWidget {
  final Datum ticket;

  const DetailTiket({Key? key, required this.ticket}) : super(key: key);

  @override
  State<DetailTiket> createState() => _DetailTiketState();
}

class _DetailTiketState extends State<DetailTiket> {
  int quantity = 1;

  String formatCurrency(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = int.parse(widget.ticket.ticketPrice) * quantity;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ticket Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.ticket.ticketImage != null &&
                      widget.ticket.ticketImage.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        '$url/tiket/${widget.ticket.ticketImage}',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.ticket.ticketName,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: Color(0xFFF4B5A4),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(widget.ticket.ticketDate),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFFF4B5A4),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          widget.ticket.ticketLoc,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.discount_outlined,
                        color: Color(0xFFF4B5A4),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        formatCurrency(int.parse(widget.ticket.ticketPrice)),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Deskripsi ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.ticket.ticketDesc ?? 'No description available.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Pilih Tiket :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Total Price : ${formatCurrency(totalPrice)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to CheckoutScreen with the selected ticket and quantity
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          ticket: widget.ticket, // Pass the selected ticket
                          quantity: quantity, // Pass the selected quantity
                          total: totalPrice,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF4B5A4),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffCC7861)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/favorite/list_favorite_screen.dart';
import 'package:uas_budaya/main.dart';
import 'package:uas_budaya/models/model_listtiket.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uas_budaya/tiket/detail_tiket.dart';
import 'package:uas_budaya/tiket/history.dart';
import 'package:uas_budaya/tiket/list_favorite_screen.dart';

class ListTiket extends StatefulWidget {
  const ListTiket({super.key});

  @override
  State<ListTiket> createState() => _ListTiketState();
}

class _ListTiketState extends State<ListTiket> {
  late Future<List<Datum>?> _futureTickets;
  List<Datum>? tickets;
  List<Datum>? filteredTickets;
  bool isLoading = true;
  String? id;
  Set<String> favoriteTicketsIds = {};
  bool isFavorite = false;

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print('id $id');
    });
  }

  Future<List<Datum>?> getTicket() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/listticket.php'));
      List<Datum>? data = modelListTiketFromJson(res.body).data;
      setState(() {
        tickets = data;
        filteredTickets = data;
      });
      return data;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  Future<void> addFavorite(String ticketId) async {
    try {
      await http.post(Uri.parse('$url/add_favorite.php'), body: {'id_ticket': ticketId, 'id_user': id});
      setState(() {
        favoriteTicketsIds.add(ticketId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> deleteFavorite(String ticketId) async {
    try {
      print('Deleting ticket with id: $ticketId'); // Log the ticket id
      final response = await http.post(
        Uri.parse('$url/deletefavorite.php'),
        body: {'id_ticket': ticketId}, // Update key to match PHP
      );

      final responseBody = response.body;
      print('Delete Favorite Response: $responseBody');

      final responseData = json.decode(responseBody);
      if (responseData['status'] == 'success') {
        setState(() {
          favoriteTicketsIds.remove(ticketId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    getSession();
    _futureTickets = getTicket();
  }
  
  void filterTickets(String query) {
    final filtered = tickets?.where((ticket) {
      final nameLower = ticket.ticketName.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredTickets = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF4B5A4),
        title: Text(
          'All Tickets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PageHistory(), // Navigate to PageHistory
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: Container(
              width: 430,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF4B5A4),
                    Color.fromARGB(255, 240, 212, 204),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explore \nBudaya',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          'images/g1.png',
                          width: 160,
                          height: 140,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) => filterTickets(value),
                        decoration: InputDecoration(
                          labelText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _futureTickets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data'));
                } else {
                  final dataToShow = filteredTickets ?? snapshot.data!;
                  return ListView.builder(
                    itemCount: dataToShow.length,
                    itemBuilder: (context, index) {
                      Datum data = dataToShow[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailTiket(ticket: data),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 234, 228),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (data.ticketImage != null &&
                                    data.ticketImage.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      '$url/tiket/${data.ticketImage}',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                SizedBox(height: 8.0),
                                Text(
                                  data.ticketName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.date_range_rounded,
                                      color: Color(0xFFF4B5A4),
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(data.ticketDate),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
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
                                    Expanded(
                                      child: Text(
                                        data.ticketLoc,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
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
                                    Text(
                                      "Rp. ${data.ticketPrice}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        favoriteTicketsIds.contains(data.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoriteTicketsIds.contains(data.id)
                                            ? Colors.red
                                            : null,
                                      ),
                                      onPressed: () {
                                        if (favoriteTicketsIds.contains(data.id)) {
                                          deleteFavorite(data.id);
                                        } else {
                                          addFavorite(data.id);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

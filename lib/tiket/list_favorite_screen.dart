import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_favorite.dart';

class ListFavoriteScreen extends StatefulWidget {
  const ListFavoriteScreen({Key? key}) : super(key: key);

  @override
  _ListFavoriteScreenState createState() => _ListFavoriteScreenState();
}

class _ListFavoriteScreenState extends State<ListFavoriteScreen> {
  Future<List<Datum>?>? _futureProduct;
  String? username, id;
  String filter = 'All';
  String searchText = '';

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      id = pref.getString("id") ?? '';
      _futureProduct = getFavoriteProducts();
    });
  }

  Future<List<Datum>?> getFavoriteProducts() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/listfavorite.php?id_user=$id'));
      if (res.statusCode == 200) {
        return modelFavoriteFromJson(res.body).data;
      } else {
        // Handle errors here
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load data")));
        // return null;
      }
    } catch (e) {
      // Handle errors here
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      // return null;
    }
  }

  Future<void> deleteFavorite(String ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('$url/deletefavorite.php'),
        body: {
          'id_ticket': ticketId,
          'id_user': id,
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted favorite, do something if needed
        print('Favorit berhasil dihapus');
        // Refresh list after deletion
        setState(() {
          _futureProduct = getFavoriteProducts();
        });
      } else {
        // Failed to delete favorite, handle error
        print('Gagal menghapus favorit: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  List<Datum> filterProductsByName(List<Datum> products) {
    if (searchText.isEmpty) {
      return List.from(products);
    }
    return products.where((product) =>
        product.ticketName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  List<Datum> filterProducts(List<Datum> products) {
    List<Datum> filteredProducts = List.from(products);
    if (filter == 'Cheapest') {
      filteredProducts.sort((a, b) => a.ticketPrice.compareTo(b.ticketPrice));
    } else if (filter == 'Expensive') {
      filteredProducts.sort((a, b) => b.ticketPrice.compareTo(a.ticketPrice));
    }
    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search something',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: Text('All'),
                  selected: filter == 'All',
                  onSelected: (bool selected) {
                    setState(() {
                      filter = 'All';
                      _futureProduct = getFavoriteProducts();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Cheapest'),
                  selected: filter == 'Cheapest',
                  onSelected: (bool selected) {
                    setState(() {
                      filter = 'Cheapest';
                      _futureProduct = getFavoriteProducts();
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Expensive'),
                  selected: filter == 'Expensive',
                  onSelected: (bool selected) {
                    setState(() {
                      filter = 'Expensive';
                      _futureProduct = getFavoriteProducts();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _futureProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No favorites found'));
                } else {
                  List<Datum> filteredProducts = filterProductsByName(filterProducts(snapshot.data!));
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      Datum favorite = filteredProducts[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  child: Image.network(
                                    '$url/tiket/${favorite.ticketImage}',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    favorite.ticketName,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: IconButton(
                                icon: Icon(Icons.favorite, color: Colors.red),
                                onPressed: () => deleteFavorite(favorite.id),
                              ),
                            ),
                          ],
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

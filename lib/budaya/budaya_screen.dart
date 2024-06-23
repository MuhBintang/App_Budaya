import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_budaya.dart';

import 'category_page.dart';
import 'detail_budaya.dart';

class ListBudaya extends StatefulWidget {
  const ListBudaya({super.key});

  @override
  State<ListBudaya> createState() => _ListBudayaState();
}

class _ListBudayaState extends State<ListBudaya> {
  List<Datum>? budayas = [];
  List<Datum>? filteredBudayas = [];
  bool isLoading = true;
  String? id;

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print('id $id');
    });
  }

  Future<void> getBudaya() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/listbudaya.php'));
      final modelListBudaya = modelListBudayaFromJson(res.body);
      setState(() {
        budayas = modelListBudaya.data;
        filteredBudayas = budayas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSession();
    getBudaya();
  }

  void filterBudayas(String query) {
    final filtered = budayas?.where((budaya) {
      final nameLower = budaya.provinsi.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredBudayas = filtered;
    });
  }

  void navigateToCategory(Pulau pulau) {
    final filteredByCategory = budayas?.where((budaya) {
      return budaya.pulau == pulau;
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(
          category: pulau,
          data: filteredByCategory ?? [],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF4B5A4),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Navigator.of(context).pushReplacement(
        //     //   MaterialPageRoute(
        //     //     builder: (context) => BottomNavBar(initialIndex: 3),
        //     //   ),
        //     // );
        //   },
        // ),
        title: Text(
          'Culture',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) => filterBudayas(value),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none, // Menghilangkan border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            BorderSide.none, // Menghilangkan border saat fokus
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => navigateToCategory(Pulau.SUMATRA),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF4B5A4), // Warna latar belakang
                        ),
                        child: Text(
                          'Sumatra',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => navigateToCategory(Pulau.JAWA),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF4B5A4), // Warna latar belakang
                        ),
                        child: Text(
                          'Jawa',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => navigateToCategory(Pulau.KALIMANTAN),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF4B5A4), // Warna latar belakang
                        ),
                        child: Text(
                          'Kalimantan',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => navigateToCategory(Pulau.SULAWESI),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF4B5A4), // Warna latar belakang
                        ),
                        child: Text(
                          'Sulawesi',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => navigateToCategory(Pulau.PAPUA),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF4B5A4), // Warna latar belakang
                        ),
                        child: Text(
                          'Papua',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredBudayas?.length ?? 0,
                    itemBuilder: (context, index) {
                      Datum data = filteredBudayas![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailBudaya(data),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Card(
                            child: ListTile(
                              minLeadingWidth: 15,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    8), // Atur radius sesuai kebutuhan
                                child: Image.network(
                                  '$url/gambar_budaya/${data.rumahAdat}',
                                  width: 120, // Atur lebar gambar
                                  height: 120, // Atur tinggi gambar
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                "${data.provinsi}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}

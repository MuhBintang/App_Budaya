import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_budaya.dart';

class BudayaScreen extends StatefulWidget {
  const BudayaScreen({super.key});

  @override
  State<BudayaScreen> createState() => _BudayaScreenState();
}

class _BudayaScreenState extends State<BudayaScreen> {
  String? id, username;
  late Future<List<Datum>?> _futureBerita;
  List<Datum> _beritaList = [];
  List<Datum> _filteredBeritaList = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureBerita = getBudaya();
    getSession(); // Panggil metode untuk mendapatkan session (nama pengguna)
  }

  Future<List<Datum>?> getBudaya() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/getBudaya.php'));
      _beritaList = modelBudayaFromJson(res.body).data ?? [];
      setState(() {
        _filteredBeritaList = _beritaList; // Inisialisasi hasil pencarian dengan semua berita
      });
      return _beritaList;
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      });
      return null;
    }
  }

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id");
      username = pref.getString("username") ?? "Guest";
    });
  }

  void filterBerita(String query) {
    List<Datum> filteredList = _beritaList.where((berita) {
      // Sesuaikan kondisi pencarian berdasarkan kebutuhan Anda
      return berita.provinsi.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredBeritaList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF4B5A4),// Warna latar belakang card
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                Text(
                  'Selamat Datang, $username',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.0), // Spasi antara teks dan daftar berita
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterBerita(value); // Panggil filterBerita setiap kali nilai TextField berubah
              },
              decoration: InputDecoration(
                hintText: 'Cari budaya...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Fungsi ini tidak perlu dipanggil untuk mencari berita, karena filterBerita dipanggil setiap kali TextField berubah
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _futureBerita,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredBeritaList.length,
                    itemBuilder: (context, index) {
                      Datum berita = _filteredBeritaList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF4B5A4),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (berita.rumahAdat != null && berita.rumahAdat.isNotEmpty)
                                Image.network('$url/gambar_budaya/${berita.rumahAdat}'),
                              SizedBox(height: 8.0),
                              Text(
                                berita.provinsi,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text('Pulau : ${berita.pulau}'),
                            ],
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/home_page/detail_home_screen.dart';
import 'package:uas_budaya/models/model_berita.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? id, username;
  late Future<List<Datum>?> _futureBerita;
  List<Datum> _beritaList = [];
  List<Datum> _filteredBeritaList = [];
  late CarouselController _carouselController;
  double _rating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();

  TextEditingController _searchController = TextEditingController();

  final List<String> _carouselImages = [
    'images/banner4.jpeg',
    'images/banner2.jpeg',
    'images/banner5.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _futureBerita = getBerita();
    _carouselController = CarouselController();
    getSession(); // Panggil metode untuk mendapatkan session (nama pengguna)
  }

  void goToPreviousSlide() {
    _carouselController.previousPage();
  }

  void goToNextSlide() {
    _carouselController.nextPage();
  }

  Future<void> _submitRating(double rating, String feedback) async {
    final String link = '$url/rating.php';  // Ganti dengan URL endpoint Anda
    try {
      var request = http.MultipartRequest('POST', Uri.parse(link));
      // request.fields['id'] = id!;
      request.fields['id_user'] = id!;
      request.fields['rating'] = rating.toString();
      request.fields['pesan'] = feedback;

      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful submission
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Rating submitted successfully'),
        ));
      } else {
        // Handle unsuccessful submission
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit rating'),
        ));
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        title: Center(
          child: Text(
            'Rating',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Beri Rate Aplikasi Kami'),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Berikan Pesan Anda',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_rating > 0) {
                await _submitRating(_rating, _feedbackController.text);
                Navigator.of(context).pop(true);
              } else {
                // Show a message if the user hasn't rated yet
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please provide a rating'),
                ));
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<List<Datum>?> getBerita() async {
    try {
      http.Response res = await http.get(Uri.parse('$url/getBerita.php'));
      _beritaList = modelBeritaFromJson(res.body).data ?? [];
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
      return berita.judul.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredBeritaList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF4B5A4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
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
                        controller: _searchController,
                        onChanged: (value) {
                          filterBerita(value);
                        },
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
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0), // Add padding to avoid cut-off shadow
                child: CarouselSlider(
                  items: _carouselImages.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black26,
                            //     spreadRadius: 3,
                            //     blurRadius: 5,
                            //     offset: Offset(0, 3), // changes position of shadow
                            //   ),
                            // ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    onPageChanged: (index, reason) {
                      // Optional: Do something when page changes
                    },
                  ),
                ),
              ),
              FutureBuilder<List<Datum>?>(
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
                      physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling
                      shrinkWrap: true,
                      itemCount: _filteredBeritaList.length,
                      itemBuilder: (context, index) {
                        Datum berita = _filteredBeritaList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(berita: berita),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF4B5A4),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (berita.gambar != null && berita.gambar.isNotEmpty)
                                    Image.network('$url/gambar_berita/${berita.gambar}'),
                                  SizedBox(height: 8.0),
                                  Text(
                                    berita.judul,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('Dibuat: ${berita.created}'),
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
            ],
          ),
        ),
      ),
    );
  }
}

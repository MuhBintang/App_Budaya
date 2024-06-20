import 'package:flutter/material.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_berita.dart';

class DetailScreen extends StatelessWidget {
  final Datum berita;

  const DetailScreen({Key? key, required this.berita}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(berita.judul),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (berita.gambar != null && berita.gambar.isNotEmpty)
                Center(child: Image.network('$url/gambar_berita/${berita.gambar}')),
              SizedBox(height: 8.0),
              Text(
                berita.judul,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold), textAlign: TextAlign.center
              ),
              SizedBox(height: 8.0),
              Text('Dibuat: ${berita.created}'),
              SizedBox(height: 8.0),
              Text(berita.konten, textAlign: TextAlign.justify,), // Asumsikan model_berita memiliki deskripsi
              SizedBox(height: 8.0),
              Text('Penulis : ${berita.author}', style: TextStyle(fontWeight: FontWeight.bold),), 
            ],
          ),
        ),
      ),
    );
  }
}

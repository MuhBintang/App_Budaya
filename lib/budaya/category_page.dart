import 'package:flutter/material.dart';
import 'package:uas_budaya/budaya/detail_budaya.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_budaya.dart';

class CategoryPage extends StatelessWidget {
  final Pulau category;
  final List<Datum> data;

  const CategoryPage({
    required this.category,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulau ${category.toString().split('.').last}'),
        backgroundColor: Color(0xFFF4B5A4),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Datum datum = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBudaya(datum),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Card(
                child: ListTile(
                  minLeadingWidth: 15,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$url/gambar_budaya/${datum.rumahAdat}',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "${datum.provinsi}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Lihat Detail",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

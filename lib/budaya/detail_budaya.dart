import 'package:flutter/material.dart';
import 'package:uas_budaya/const.dart';
import 'package:uas_budaya/models/model_budaya.dart';

class DetailBudaya extends StatefulWidget {
  final Datum? data;

  DetailBudaya(this.data);

  @override
  State<DetailBudaya> createState() => _DetailBudayaState();
}

class _DetailBudayaState extends State<DetailBudaya> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Budaya",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF4B5A4),
      ),
      body: ListView(
        children: [
          Image.network(
            '$url/gambar_budaya/${widget.data?.rumahAdat ?? ''}',
            fit: BoxFit.fill,
          ),
          Container(
            // margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.data?.provinsi ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color.fromARGB(255, 213, 99, 99),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.data?.deskripsi ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28, // Atur radius lingkaran sesuai kebutuhan
                        backgroundColor: const Color(0xFFF4B5A4),
                        child: ClipOval(
                          // Gunakan ClipOval untuk membuat gambar memiliki radius circular
                          child: Image.asset(
                            "icon/baju.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data?.pakaian ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28, // Atur radius lingkaran sesuai kebutuhan
                        backgroundColor: const Color(0xFFF4B5A4),
                        child: ClipOval(
                          // Gunakan ClipOval untuk membuat gambar memiliki radius circular
                          child: Image.asset(
                            "icon/tari.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data?.tari ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28, // Atur radius lingkaran sesuai kebutuhan
                        backgroundColor: const Color(0xFFF4B5A4),
                        child: ClipOval(
                          // Gunakan ClipOval untuk membuat gambar memiliki radius circular
                          child: Image.asset(
                            "icon/senjata.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data?.senjata ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28, // Atur radius lingkaran sesuai kebutuhan
                        backgroundColor: const Color(0xFFF4B5A4),
                        child: ClipOval(
                          // Gunakan ClipOval untuk membuat gambar memiliki radius circular
                          child: Image.asset(
                            "icon/suku.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data?.suku ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28, // Atur radius lingkaran sesuai kebutuhan
                        backgroundColor: const Color(0xFFF4B5A4),
                        child: ClipOval(
                          // Gunakan ClipOval untuk membuat gambar memiliki radius circular
                          child: Image.asset(
                            "icon/makanan.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data?.makanan ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

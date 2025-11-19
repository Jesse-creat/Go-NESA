import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_view.dart';

class GojekAppBar extends AppBar {
  GojekAppBar()
      : super(
            elevation: 0.25,
            backgroundColor: Colors.white,
            flexibleSpace: _buildGojekAppBar());

  static Widget _buildGojekAppBar() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                "assets/Go.png",
                height: 300.0,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    // Tombol baru untuk riwayat pesanan
                    IconButton(
                      icon: Icon(Icons.receipt_long, color: Colors.grey[700]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PesananView()),
                        );
                      },
                    ),
                    SizedBox(width: 16.0), // Jarak antara tombol
                    Container(
                      height: 28.0,
                      width: 28.0,
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          color: Colors.orangeAccent),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.local_bar,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          color: const Color(0x50FFD180)),
                      child: const Text(
                        "1.781 poin",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

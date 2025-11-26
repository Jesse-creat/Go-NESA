import 'package:flutter/material.dart';

class PencarianView extends StatefulWidget {
  const PencarianView({Key? key}) : super(key: key);

  @override
  _PencarianViewState createState() => _PencarianViewState();
}

class _PencarianViewState extends State<PencarianView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari layanan, makanan, & tujuan...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          style: TextStyle(color: Colors.grey[900], fontSize: 16.0),
          onChanged: (value) {
            // Handle search query changes
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Halaman Hasil Pencarian'),
      ),
    );
  }
}

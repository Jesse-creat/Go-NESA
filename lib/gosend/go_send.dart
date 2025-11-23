import 'package:flutter/material.dart';

class GoSendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GO-SEND')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Kirim paket dengan mudah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12.0),
            TextField(decoration: InputDecoration(labelText: 'Alamat pengambilan')),
            SizedBox(height: 8.0),
            TextField(decoration: InputDecoration(labelText: 'Alamat tujuan')),
            SizedBox(height: 12.0),
            RaisedButton(onPressed: () {}, color: Colors.green, child: Text('Pesan Sekarang', style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GoPulsaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GO-PULSA')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(decoration: InputDecoration(labelText: 'Nomor Handphone')),
            SizedBox(height: 8.0),
            DropdownButtonFormField<int>(
              items: [50, 100, 200, 500].map((nom) => DropdownMenuItem(value: nom, child: Text('Pulsa ${nom}rb'))).toList(),
              onChanged: (v) {},
              decoration: InputDecoration(labelText: 'Nominal')), 
            SizedBox(height: 12.0),
            RaisedButton(onPressed: () {}, color: Colors.orange, child: Text('Beli Pulsa', style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}

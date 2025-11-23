import 'package:flutter/material.dart';

class GoDealsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GO-DEALS')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: List.generate(6, (i) {
          return Card(
            margin: EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: Icon(Icons.local_offer, color: Colors.purple),
              title: Text('Promo ${i + 1} - Diskon ${10 + i * 5}%'),
              subtitle: Text('Berlaku sampai ${(i + 3)} hari lagi'),
              trailing: RaisedButton(onPressed: () {}, child: Text('Dapatkan')),
            ),
          );
        }),
      ),
    );
  }
}

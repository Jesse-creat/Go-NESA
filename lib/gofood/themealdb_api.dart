import 'package:flutter/material.dart';

class GoFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GO-FOOD'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Text('Pilihan Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.0),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(6, (index) {
              return Card(
                elevation: 1,
                margin: EdgeInsets.all(6),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.restaurant_menu, color: Colors.redAccent),
                        SizedBox(height: 8.0),
                        Text('Makanan ${index + 1}', style: TextStyle(fontSize: 12))
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 18.0),
          Text('Rekomendasi Teratas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.0),
          Column(
            children: List.generate(4, (i) {
              return ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset('assets/images/food_${i + 1}.jpg', width: 56, height: 56, fit: BoxFit.cover)),
                title: Text('Restoran ${i + 1}'),
                subtitle: Text('Rating 4.${i+1} • 15-25 menit'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              );
            }),
          ),
        ],
      ),
    );
  }
}

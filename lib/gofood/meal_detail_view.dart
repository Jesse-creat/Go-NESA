import 'package:flutter/material.dart';
import 'package:gojek/gofood/meal_model.dart';
import 'package:gojek/pesanan/pesanan_model.dart';

class MealDetailView extends StatelessWidget {
  final Meal meal;

  const MealDetailView({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Harga dummy untuk makanan
    const double mealPrice = 15000;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              meal.thumbnail,
              fit: BoxFit.cover,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kategori: ${meal.category ?? 'N/A'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Asal: ${meal.area ?? 'N/A'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rp ${mealPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Instruksi:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.instructions ?? 'Tidak ada instruksi khusus.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Tambah ke Pesanan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            OrderData.addToCart(meal);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${meal.name} ditambahkan ke pesanan.'),
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

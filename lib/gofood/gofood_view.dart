import 'package:flutter/material.dart';
import 'package:gojek/gofood/cart_view.dart';
import 'package:gojek/gofood/meal_detail_view.dart';
import 'package:gojek/gofood/meal_model.dart';
import 'package:gojek/gofood/themealdb_api.dart';

class GofoodView extends StatefulWidget {
  const GofoodView({super.key});

  @override
  State<GofoodView> createState() => _GofoodViewState();
}

class _GofoodViewState extends State<GofoodView> {
  final ThemealdbApi _api = ThemealdbApi();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    // contoh: ambil kategori Seafood
    _mealsFuture = _api.getMealsByCategory('Seafood');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO-FOOD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartView()),
              ).then((_) => setState(() {})); // Refresh state saat kembali dari cart
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Meal>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final meals = snapshot.data ?? [];

          if (meals.isEmpty) {
            return const Center(
              child: Text('Tidak ada data makanan.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: meals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    meal.thumbnail,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                title: Text(
                  meal.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  meal.category ?? 'Kategori tidak diketahui',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  // Ambil detail lengkap dari API
                  final mealDetail = await _api.getMealDetail(meal.id);
                  if (mounted && mealDetail != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailView(meal: mealDetail),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

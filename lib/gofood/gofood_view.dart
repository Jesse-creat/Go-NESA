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
              ).then((_) => setState(() {}));
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
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          final meals = snapshot.data ?? [];
          if (meals.isEmpty) {
            return const Center(child: Text('Tidak ada data makanan.'));
          }

          // Menggunakan ListView dengan Card untuk tata letak yang lebih andal
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: InkWell(
                  onTap: () async {
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: meal.thumbnail.trim().isNotEmpty
                              ? Image.network(
                                  meal.thumbnail,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Icon(Icons.broken_image, size: 40),
                                    );
                                  },
                                )
                              : const SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Icon(Icons.fastfood, size: 40),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                meal.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                meal.category ?? 'Kategori tidak diketahui',
                                style: TextStyle(color: Colors.grey.shade700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

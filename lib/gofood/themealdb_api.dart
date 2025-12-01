import 'dart:convert';
import 'package:http/http.dart' as http;

import 'meal_model.dart';

class ThemealdbApi {
  // v1/1 = API v1 + test API key "1"
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final http.Client _client;

  ThemealdbApi({http.Client? client}) : _client = client ?? http.Client();

  /// Contoh: ambil makanan berdasarkan kategori, misal 'Seafood'
  Future<List<Meal>> getMealsByCategory(String category) async {
    final uri = Uri.parse('$_baseUrl/filter.php?c=$category');

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat meal (category=$category): ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic>? mealsJson = data['meals'];

    if (mealsJson == null) return [];

    // endpoint filter.php hanya mengembalikan idMeal, strMeal, strMealThumb
    return mealsJson.map((e) {
      final map = e as Map<String, dynamic>;
      return Meal(
        id: map['idMeal'] ?? '',
        name: map['strMeal'] ?? '',
        thumbnail: map['strMealThumb'] ?? '',
      );
    }).toList();
  }

  /// Kalau nanti mau detail resep:
  Future<Meal?> getMealDetail(String idMeal) async {
    final uri = Uri.parse('$_baseUrl/lookup.php?i=$idMeal');

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail meal: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic>? mealsJson = data['meals'];

    if (mealsJson == null || mealsJson.isEmpty) return null;

    return Meal.fromJson(mealsJson.first as Map<String, dynamic>);
  }
}

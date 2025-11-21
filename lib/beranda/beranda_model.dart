import 'package:flutter/material.dart';

/// Model untuk layanan Gojek (GO-RIDE, GO-CAR, dll)
class GojekService {
  final IconData image;
  final Color color;
  final String title;
  final String? subtitle; // Opsional: deskripsi singkat layanan
  final bool isNew; // Menandai layanan baru

  GojekService({
    required this.image,
    required this.title,
    required this.color,
    this.subtitle,
    this.isNew = false,
  });
}

/// Model untuk makanan/restoran
class Food {
  final String title;
  final String image;
  final double rating; // Rating 0-5
  final int deliveryTime; // Waktu pengiriman dalam menit
  final String? distance; // Jarak restoran (opsional)
  final bool isFavorite; // Status favorit
  final String? priceRange; // Range harga (misal: "Rp 15.000 - 50.000")
  final List<String>? categories; // Kategori makanan (misal: ["Steak", "Western"])

  Food({
    required this.title,
    required this.image,
    this.rating = 4.5,
    this.deliveryTime = 20,
    this.distance,
    this.isFavorite = false,
    this.priceRange,
    this.categories,
  });

  /// Copy with method untuk update state
  Food copyWith({
    String? title,
    String? image,
    double? rating,
    int? deliveryTime,
    String? distance,
    bool? isFavorite,
    String? priceRange,
    List<String>? categories,
  }) {
    return Food(
      title: title ?? this.title,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      distance: distance ?? this.distance,
      isFavorite: isFavorite ?? this.isFavorite,
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
    );
  }
}

/// Model untuk promo/banner
class Promo {
  final String image;
  final String title;
  final String content;
  final String button;
  final Color? backgroundColor; // Warna background card promo
  final Color? textColor; // Warna text
  final String? promoCode; // Kode promo jika ada
  final DateTime? validUntil; // Tanggal berlaku promo
  final String? discountPercentage; // Persentase diskon (misal: "50%")

  Promo({
    required this.image,
    required this.title,
    required this.content,
    required this.button,
    this.backgroundColor,
    this.textColor,
    this.promoCode,
    this.validUntil,
    this.discountPercentage,
  });

  /// Check apakah promo masih berlaku
  bool get isValid {
    if (validUntil == null) return true;
    return DateTime.now().isBefore(validUntil!);
  }

  /// Format tanggal berlaku untuk display
  String get validUntilFormatted {
    if (validUntil == null) return '';
    return '${validUntil!.day}/${validUntil!.month}/${validUntil!.year}';
  }
}

/// Model untuk banner/carousel (opsional, untuk menambah variasi)
class Banner {
  final String image;
  final String title;
  final String? subtitle;
  final String? actionUrl; // URL atau route tujuan
  final Color? overlayColor; // Warna overlay untuk text readability

  Banner({
    required this.image,
    required this.title,
    this.subtitle,
    this.actionUrl,
    this.overlayColor,
  });
}

/// Model untuk kategori GO-FOOD (opsional)
class FoodCategory {
  final String name;
  final IconData icon;
  final Color color;
  final int itemCount; // Jumlah item dalam kategori

  FoodCategory({
    required this.name,
    required this.icon,
    required this.color,
    this.itemCount = 0,
  });
}
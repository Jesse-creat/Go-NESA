import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gojek/gofood/meal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Kelas untuk item di keranjang belanja
class CartItem {
  final Meal meal;
  int quantity;

  CartItem({required this.meal, this.quantity = 1});

  // Untuk menyimpan dan memuat dari SharedPreferences
  Map<String, dynamic> toJson() => {
        'meal': meal.toJson(), // Asumsi Meal punya method toJson()
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        meal: Meal.fromJson(json['meal']),
        quantity: json['quantity'],
      );
}

class Order {
  final String id;
  final String serviceName;
  final DateTime orderTime;
  final double totalPrice;
  final String paymentMethod; // "QRIS", "Bayar di Tempat"
  final List<CartItem>? items; // Untuk Go-Food
  final String? from; // Untuk Go-Ride/Car
  final String? to; // Untuk Go-Ride/Car

  Order({
    required this.id,
    required this.serviceName,
    required this.orderTime,
    required this.totalPrice,
    required this.paymentMethod,
    this.items,
    this.from,
    this.to,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceName': serviceName,
        'orderTime': orderTime.toIso8601String(),
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'items': items?.map((item) => item.toJson()).toList(),
        'from': from,
        'to': to,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        serviceName: json['serviceName'],
        orderTime: DateTime.parse(json['orderTime']),
        totalPrice: json['totalPrice'],
        paymentMethod: json['paymentMethod'],
        items: (json['items'] as List<dynamic>?)
            ?.map((itemJson) => CartItem.fromJson(itemJson))
            .toList(),
        from: json['from'],
        to: json['to'],
      );
}

class OrderData {
  static List<Order> history = [];
  static List<CartItem> shoppingCart = [];
  static double currentBalance = 0.0;
  static int currentPoints = 0;
  static const _historyKey = 'orderHistory';
  static const _balanceKey = 'currentBalance';
  static const _cartKey = 'shoppingCart';
  static const _pointsKey = 'currentPoints';

  // --- Manajemen Poin ---
  static Future<void> addPoints(int points) async {
    currentPoints += points;
    await savePoints();
  }

  static Future<void> savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, currentPoints);
  }

  static Future<void> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    currentPoints = prefs.getInt(_pointsKey) ?? 0;
  }

  // --- Manajemen Keranjang Belanja ---
  static void addToCart(Meal meal) {
    // Cek apakah item sudah ada di keranjang
    for (var item in shoppingCart) {
      if (item.meal.id == meal.id) {
        item.quantity++;
        saveCart();
        return;
      }
    }
    // Jika belum ada, tambahkan item baru
    shoppingCart.add(CartItem(meal: meal));
    saveCart();
  }

  static void removeFromCart(CartItem cartItem) {
    shoppingCart.removeWhere((item) => item.meal.id == cartItem.meal.id);
    saveCart();
  }

  static void clearCart() {
    shoppingCart.clear();
    saveCart();
  }

  static double getCartTotal() {
    double total = 0;
    for (var item in shoppingCart) {
      // Asumsi setiap makanan punya harga, kita buat harga dummy 15000
      total += (15000 * item.quantity);
    }
    return total;
  }

  static Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartJson =
        shoppingCart.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartJson);
  }

  static Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartJson = prefs.getStringList(_cartKey);
    if (cartJson != null) {
      shoppingCart = cartJson
          .map((itemJson) => CartItem.fromJson(json.decode(itemJson)))
          .toList();
    }
  }

  // --- Manajemen Order History & Saldo ---
  static Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> ordersJson =
        history.map((order) => json.encode(order.toJson())).toList();
    await prefs.setStringList(_historyKey, ordersJson);
  }

  static Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ordersJson = prefs.getStringList(_historyKey);
    if (ordersJson != null) {
      history = ordersJson
          .map((orderJson) => Order.fromJson(json.decode(orderJson)))
          .toList();
    }
  }

  static Future<void> saveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, currentBalance);
  }

  static Future<void> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    currentBalance = prefs.getDouble(_balanceKey) ?? 120000.0;
  }
}

// Perlu menambahkan method toJson() ke Meal class
extension MealJson on Meal {
  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': name,
        'strMealThumb': thumbnail,
        'strCategory': category,
        'strArea': area,
        'strInstructions': instructions,
      };
}

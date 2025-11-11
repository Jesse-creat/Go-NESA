import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order {
  final IconData serviceIcon;
  final String serviceName;
  final String from;
  final String to;
  final String price;
  final DateTime orderTime;

  Order({
    required this.serviceIcon,
    required this.serviceName,
    required this.from,
    required this.to,
    required this.price,
    required this.orderTime,
  });

  Map<String, dynamic> toJson() => {
        'serviceIcon': serviceIcon.codePoint,
        'serviceName': serviceName,
        'from': from,
        'to': to,
        'price': price,
        'orderTime': orderTime.toIso8601String(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        serviceIcon: IconData(json['serviceIcon'], fontFamily: 'MaterialIcons'),
        serviceName: json['serviceName'],
        from: json['from'],
        to: json['to'],
        price: json['price'],
        orderTime: DateTime.parse(json['orderTime']),
      );
}

class OrderData {
  static List<Order> history = [];
  static double currentBalance = 0.0; // Saldo awal
  static const _historyKey = 'orderHistory';
  static const _balanceKey = 'currentBalance';

  static Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> ordersJson = history.map((order) => json.encode(order.toJson())).toList();
    await prefs.setStringList(_historyKey, ordersJson);
  }

  static Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ordersJson = prefs.getStringList(_historyKey);
    if (ordersJson != null) {
      history = ordersJson.map((orderJson) => Order.fromJson(json.decode(orderJson))).toList();
    }
  }

  static Future<void> saveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, currentBalance);
  }

  static Future<void> loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    currentBalance = prefs.getDouble(_balanceKey) ?? 120000.0; // Saldo default jika belum ada
  }
}

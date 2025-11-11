import 'package:flutter/material.dart';

class GojekService {
  final IconData image;
  final Color color;
  final String title;

  GojekService({required this.image, required this.title, required this.color});
}

class Food {
  final String title;
  final String image;
  Food({required this.title, required this.image});
}

class Promo{
  final String image;
  final String title;
  final String content;
  final String button;

  Promo({required this.image, required this.title, required this.content, required this.button});
}

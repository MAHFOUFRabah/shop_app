import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url =
        'https://flutter-udemy-shop-app-57d19.firebaseio.com/userFavorites/$userId/${id}.json?auth=$authToken';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        notifyListeners();
      }
    } catch (error) {
      _setFavValue(oldStatus);
      notifyListeners();
    }
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirDate;
  String _userId;
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expirDate != null &&
        _expirDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyBxeNVvL8LXF0cVIRwt1Gnql_Z6rMjM75U';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      print(responseData['error']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    const urlSegment = 'accounts:signUp';
    return _authenticate(email, password, urlSegment);
  }

  Future<void> login(String email, String password) async {
    const urlSegment = 'accounts:signInWithPassword';
    return _authenticate(email, password, urlSegment);
  }
}
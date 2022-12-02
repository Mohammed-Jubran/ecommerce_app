import 'dart:convert';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> cartItems = [];
  late SharedPreferences _prefs;
  num cartTotalAmount = 0;

  getCart() async {
    cartTotalAmount = 0;
    _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.getString(Constants.ID);
    cartItems = [];
    final response = await http.post(Uri.parse('${Constants.URL}GetCart.php'),
        body: {'Id_users': userId});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var items = jsonBody['cart'];
      for (Map i in items) {
        cartTotalAmount += i['Price'] * i['Count'];
        cartItems.add(CartItem(
            id: i['Id'],
            itemId: i['Id_items'],
            name: i['Name'],
            count: i['Count'],
            price: i['Price'] * i['Count'],
            imageUrl: i['ImageUrl']));
      }
    }
    notifyListeners();
  }

  addToCart({required String itemId}) async {
    _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.getString(Constants.ID);
    cartItems = [];
    final response = await http.post(Uri.parse('${Constants.URL}AddToCart.php'),
        body: {'Id_users': userId, 'Id_items': itemId});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
    }
    notifyListeners();
  }

  updateCart({required int count, required String itemId}) async {
    _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.getString(Constants.ID);
    cartItems = [];
    final response = await http.post(
        Uri.parse('${Constants.URL}UpdateCart.php'),
        body: {'Id_users': userId, 'Id_items': itemId, 'Count': count});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
    }
    notifyListeners();
  }
}

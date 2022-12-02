import 'dart:convert';

import 'package:ecommerce_app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemsProvider extends ChangeNotifier {
  List<Item> items = [];

  getItems(int shopId) async {
    items = [];
    final response = await http.post(
        Uri.parse('http://alshalbiapps.com/API/GetItems.php'),
        body: {'Id_shopes': shopId.toString()});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var items = jsonBody['items'];
      for (Map i in items) {
        this.items.add(Item(
            name: i['Name'],
            imageUrl: i['ImageUrl'],
            id: i['Id'],
            price: i['Price'],
            description: i['Description']));
      }
    }
    notifyListeners();
  }
}

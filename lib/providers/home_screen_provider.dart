import 'dart:convert';

import 'package:ecommerce_app/models/banner_images.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenProvider extends ChangeNotifier {
  List<BannerImages> bannerImages = [];
  List<Category> categories = [];
  List<Shop> shops = [];

  getBannerImages() async {
    final response = await http
        .get(Uri.parse('http://alshalbiapps.com/API/getbannerimages.php'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var images = jsonBody['Images'];
      for (Map i in images) {
        bannerImages.add(BannerImages(i['Id'], i['ImageURL']));
      }
    }
    notifyListeners();
  }

  getCategories() async {
    categories = [];
    final response = await http
        .get(Uri.parse('http://alshalbiapps.com/API/GetCategories.php'));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var categories = jsonBody['categories'];
      for (Map i in categories) {
        this.categories.add(
            Category(id: i['Id'], name: i['Name'], imageUrl: i['ImageUrl']));
      }
    }
    notifyListeners();
  }

  getShops(String categoryId) async {
    shops = [];
    final response = await http.post(
        Uri.parse('http://alshalbiapps.com/API/getshopes.php'),
        body: {'Id_categories': categoryId});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var shops = jsonBody['shopes'];
      for (Map i in shops) {
        this
            .shops
            .add(Shop(name: i['Name'], imageUrl: i['Image'], id: i['Id']));
      }
    }
    notifyListeners();
  }
}

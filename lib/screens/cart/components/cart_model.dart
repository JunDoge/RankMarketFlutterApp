import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List<int> _prdIds = [];
  List<int> _price = [];
  List<String> _title = [];
  int totalPrice = 0;

  List<int> get prdIds => _prdIds.toList();
  List<int> get price => _price.toList();
  List<String> get title => _title;
  void addToCart(int prdId, int winPrice, title) {
    _prdIds.add(prdId);
    _price.add(winPrice);
    totalPrice += winPrice;
    _title.add(title);
    notifyListeners();
  }

  void removeFromCart(int prdId, int winPrice, String title) {
    _prdIds.remove(prdId);
    _price.remove(winPrice);
    totalPrice -= winPrice;
    _title.remove(title);
    notifyListeners();
  }
}

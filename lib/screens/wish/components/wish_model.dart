import 'package:flutter/material.dart';

class WishModel extends ChangeNotifier {
  List<int> _prdIds = [];

  List<int> get prdIds => _prdIds.toList();

  void addToCart(int prdId) {
    _prdIds.add(prdId);
    notifyListeners();
  }

  void removeFromCart(int prdId) {
    _prdIds.remove(prdId);
    notifyListeners();
  }
}

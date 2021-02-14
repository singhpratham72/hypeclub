import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Order with ChangeNotifier {
  String orderID;
  int price;
  List items;
  Timestamp orderDate;
  String address;

  Order({this.orderID, this.price, this.items, this.orderDate, this.address});

  DateTime get orderDateTime => orderDate.toDate();

  void updateItems(List newItems) {
    items = newItems;
    notifyListeners();
  }

  void updateAddress(String newAddress) {
    address = newAddress;
    notifyListeners();
  }

  //
  void updateID(String newID) {
    orderID = newID;
    notifyListeners();
  }

  //
  void updateDate() {
    orderDate = Timestamp.fromDate(DateTime.now());
    notifyListeners();
  }

  void updatePrice(int newPrice) {
    price = newPrice;
    notifyListeners();
  }

  Map<String, dynamic> getOrderMap() {
    Map<String, dynamic> orderMap = {
      'orderID': orderID,
      'items': items,
      'price': price,
      'address': address,
      'orderDate': orderDate
    };
    return orderMap;
  }
}

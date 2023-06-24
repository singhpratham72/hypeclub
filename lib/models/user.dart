import 'package:aponline/services/db_service.dart';
import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  DatabaseService db = DatabaseService();

  String name, phone, email;
  List cart, wishlist, orders = [];
  User({
    this.name,
    this.phone,
    this.email,
    this.cart,
    this.wishlist,
    this.orders,
  });

  String getProductSize(String id) {
    String size = "Z";
    cart.forEach((item) {
      if (item['id'] == id) {
        size = item['size'];
      }
    });
    return size;
  }

  void removeProductFromCart(String id) {
    for (Map<String, dynamic> item in cart) {
      if (item['id'] == id) {
        cart.remove(item);
        break;
      }
    }
  }

  List<String> getCartProductIDs() {
    List<String> cartIDs = [];
    cart.forEach((item) {
      cartIDs.add(item['id']);
    });
    return cartIDs;
  }

  factory User.fromMap(Map data) {
    return User(
        name: data['name'],
        phone: data['phone'],
        email: data['email'],
        cart: data['cart'],
        wishlist: data['wishlist'],
        orders: data['orders']);
  }

  // void cancelBooking(Map booking) {
  //   bookings.remove(booking);
  //   notifyListeners();
  // }

  Map<String, dynamic> getUserMap() {
    Map<String, dynamic> userData = {
      'name': name,
      'phone': phone,
      'email': email,
      'cart': cart,
      'wishlist': wishlist,
      'orders': orders,
    };
    return userData;
  }
}

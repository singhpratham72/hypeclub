import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aponline/models/user.dart' as userModel;

class DatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('Products');

  Future<void> addUser({String name, String phone}) async {
    List<dynamic> dummyList = [];
    Map<String, dynamic> userData = {
      'name': name,
      'phone': phone,
      'email': _firebaseAuth.currentUser.email,
      'wishlist': dummyList,
      'orders': dummyList
    };
    return await usersRef.doc(_firebaseAuth.currentUser.uid).set(userData);
  }

  Future<userModel.User> getUser() async {
    var snap = await usersRef.doc(_firebaseAuth.currentUser.uid).get();
    return userModel.User.fromMap(snap.data());
  }

  Stream<userModel.User> userStream() {
    return usersRef
        .doc(_firebaseAuth.currentUser.uid)
        .snapshots()
        .map((snap) => userModel.User.fromMap(snap.data()));
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    return await usersRef.doc(_firebaseAuth.currentUser.uid).update(userData);
  }

  // Future<void> addBooking(Map<String, dynamic> bookingData) async {
  //   return await usersRef
  //       .doc(_firebaseAuth.currentUser.uid)
  //       .update({'bookings': bookingData});
  // }

  Future addReview(
      {String productID, String review, int rating, String name}) async {
    Map<String, dynamic> reviewData = {
      'review': review,
      'rating': rating,
      'userName': name
    };
    return await productsRef
        .doc(productID)
        .collection('Reviews')
        .doc(_firebaseAuth.currentUser.uid)
        .set(reviewData);
  }

  Future<void> addSearchString() async {
    QuerySnapshot products = await productsRef.get();
    products.docs.forEach((product) {
      String name = product.data()['name'];
      String searchString = name.substring(0, 1);
      productsRef.doc(product.id).update({'searchString': searchString});
      print(searchString);
    });
  }

  Future<DocumentReference> addProduct() async {
    List images = [
      'https://assets.ajio.com/medias/sys_master/root/20201030/KpdZ/5f9c2e61f997dd8c837fd59d/-473Wx593H-460757243-navy-MODEL.jpg',
      'https://assets.ajio.com/medias/sys_master/root/20201030/N9zY/5f9c2cd6aeb269d563f58028/-473Wx593H-460757243-navy-MODEL5.jpg'
    ];
    Map<String, dynamic> productData = {
      'desc': 'A durable running shoe.',
      'name': 'Arpen 87',
      'price': 1499,
      'size': ['6', '7', '8', '9'],
      'gender': 'M',
      'type': 'sandals',
      'images': images
    };

    return await productsRef.add(productData);
  }

  Future<QuerySnapshot> searchProductByName(String searchField) async {
    return await productsRef
        .where('searchString',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  Future<Map> getProductData(String productID) async {
    return await productsRef
        .doc(productID)
        .get()
        .then((productData) => productData.data());
  }

  Future<int> getProductPrice(String productID) async {
    DocumentSnapshot snapshot = await productsRef.doc(productID).get();
    Map product = snapshot.data();
    print('ProductPrice: ${product['price']}');
    return product['price'];
  }

  Future<int> getCartTotal(List cart) async {
    int total = 0;
    for (Map item in cart) {
      int price = await getProductPrice(item['id']);
      total = total + price;
    }
    return total;
  }

  Future<bool> checkGoogleConnect() async {
    List<String> signInMethods = await _firebaseAuth
        .fetchSignInMethodsForEmail(_firebaseAuth.currentUser.email);
    return signInMethods.contains('google.com');
  }
}

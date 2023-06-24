import 'package:aponline/screens/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/services/db_service.dart';

import '../constants.dart';

class WishlistTab extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user.wishlist.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: FutureBuilder<QuerySnapshot>(
              future: db.productsRef.get(),
              builder: (context, snapshot) {
                // Snap error
                if (snapshot.hasError) return Text('ErrorL ${snapshot.error}');

                //Snap connected
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(bottom: 24.0, top: 12.0),
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((productDoc) {
                      if (user.wishlist.contains(productDoc.id)) {
                        Map<String, dynamic> productData = productDoc.data();
                        return ProductCardW(
                            id: productDoc.id,
                            name: productData['name'],
                            price: productData['price'],
                            url: productData['images'][0],
                            type: productData['type']);
                      } else
                        return SizedBox(
                          height: 0.0,
                        );
                    }).toList(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Text('You don\'t have any saved items.'),
          );
  }
}

//Wishlist Product Card
class ProductCardW extends StatelessWidget {
  final String id, name, url, type;
  final int price;

  ProductCardW({
    this.id,
    this.name,
    this.type,
    this.url,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                  value: user,
                  child: ProductScreen(
                    productID: id,
                  )),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
        padding: EdgeInsets.only(right: 16.0),
        height: 124.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.15),
                  spreadRadius: 2.0,
                  blurRadius: 10.0,
                  offset: Offset(9, 9))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(url))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: cardText.copyWith(fontSize: 16.0),
                    ),
                    Text(
                      '₹$price',
                      style: highlightText.copyWith(fontSize: 20.0),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt,
                              color: Theme.of(context).primaryColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sturdiness',
                                  style: headingText.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '4/5',
                                  style: headingText.copyWith(
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Theme.of(context).primaryColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Durability',
                                  style: headingText.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '5/5',
                                  style: headingText.copyWith(
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  user.wishlist.remove(id);
                  await db.updateUser(user.getUserMap());
                },
                icon: Icon(
                  Icons.delete_sharp,
                  size: 32.0,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

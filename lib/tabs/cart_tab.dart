import 'package:aponline/models/order.dart';
import 'package:aponline/screens/checkout_screen.dart';
import 'package:aponline/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/services/db_service.dart';

import '../constants.dart';

class CartTab extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    int cartPrice = 0;
    final user = Provider.of<User>(context);
    if (user.cart.isNotEmpty) {
      List<Widget> cards = [];
      for (Map item in user.cart) {
        cards.add(ProductCardC(
          id: item['id'],
          size: item['size'],
        ));
      }
      return Stack(children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: ListView(
            padding: EdgeInsets.only(bottom: 24.0, top: 12.0),
            shrinkWrap: true,
            children: cards,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0.0),
            height: 96.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFEFEEEE).withOpacity(0.82),
                    spreadRadius: 5.0,
                    blurRadius: 7,
                    offset: Offset(0, 0))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                    future: db.getCartTotal(user.cart),
                    builder: (context, AsyncSnapshot<int> total) {
                      cartPrice = total.data;
                      return Text(
                        '\u2022 ₹${total.data}.0',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: Theme.of(context).accentColor),
                      );
                    }),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Color(0xff757575),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (context) => Order(),
                          ),
                          ChangeNotifierProvider.value(value: user)
                        ],
                        child: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                bottom: 30.0,
                                right: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32.0),
                                topLeft: Radius.circular(32.0),
                              ),
                            ),
                            child: CheckoutBottomSheet(cartTotal: cartPrice),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context).accentColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Checkout",
                          style: buttonText.copyWith(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]);
    } else {
      return Center(
        child: Text('Your cart is empty.'),
      );
    }
  }
}

//Cart Product Card
class ProductCardC extends StatelessWidget {
  final String id, size;

  ProductCardC({this.id, this.size});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    final user = Provider.of<User>(context);

    return FutureBuilder(
      future: db.getProductData(id),
      builder: (context, AsyncSnapshot<Map> productData) {
        Map productMap = productData.data;
        if (productData.connectionState == ConnectionState.done) {
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
                              fit: BoxFit.cover,
                              image: NetworkImage(productMap['images'][0]))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productMap['name'],
                            style: cardText.copyWith(fontSize: 16.0),
                          ),
                          Row(
                            children: [
                              Text('Size: '),
                              Text(
                                size,
                                style: greyText.copyWith(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Text(
                            '₹${productMap['price']}',
                            style: highlightText.copyWith(fontSize: 14.0),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.signal_cellular_alt,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.add_outlined,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Type',
                                        style: headingText.copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        productMap['type'],
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
                        user.removeProductFromCart(id);
                        await db.updateUser(user.getUserMap());
                      },
                      icon: Icon(
                        Icons.delete_sharp,
                        size: 32.0,
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

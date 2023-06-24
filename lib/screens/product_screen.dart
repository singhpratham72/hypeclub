import 'package:aponline/widgets/product_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/services/db_service.dart';
import 'package:aponline/widgets/add_review.dart';
import 'package:aponline/widgets/review_card.dart';
import 'package:aponline/widgets/image_swipe.dart';

import '../constants.dart';

class ProductScreen extends StatefulWidget {
  final String productID;
  ProductScreen({@required this.productID});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final DatabaseService db = DatabaseService();
  String _selectedProductSize = "";

  void reviewAdder() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    bool hasPurchasedProduct() {
      if (user.orders.isEmpty) {
        return false;
      }
      return true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder(
            future: db.productsRef.doc(widget.productID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> productData = snapshot.data.data();
                List imageList = productData['images'];
                List productSizes = productData['size'];
                _selectedProductSize = productSizes[0];
                return Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ImageSwipe(
                          imageList: imageList,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, left: 20.0, right: 20.0, bottom: 96.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productData['name'],
                                style: cardText.copyWith(fontSize: 20.0),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  productData['desc'],
                                  style: greyText.copyWith(fontSize: 16.0),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          '₹${productData['price']}',
                                          style:
                                              cardText.copyWith(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Reviews',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          '4.0 \u2605\u2605\u2605\u2605',
                                          style: highlightText.copyWith(
                                              fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'View Counter',
                                          style: greyText,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          '3',
                                          style:
                                              cardText.copyWith(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Highlights',
                                style: cardText.copyWith(fontSize: 20.0),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 24.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.signal_cellular_alt,
                                          color: Theme.of(context).primaryColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Durability',
                                              style: headingText.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '4/5',
                                              style: headingText.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Theme.of(context).primaryColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Long-Lasting',
                                              style: headingText.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '5/5',
                                              style: headingText.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.height,
                                          color: Theme.of(context).primaryColor,
                                          size: 28.0,
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Range',
                                              style: headingText.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '4/5',
                                              style: headingText.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Size',
                                      style: cardText.copyWith(fontSize: 20.0),
                                    ),
                                    ProductSize(
                                      productSizes: productSizes,
                                      onSelected: (size) {
                                        _selectedProductSize = size;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Customer Reviews',
                                    style: cardText.copyWith(fontSize: 20.0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      bool hasProduct = hasPurchasedProduct();
                                      if (hasProduct) {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => AddReview(
                                                  setState: reviewAdder,
                                                  userName: user.name,
                                                  productID: widget.productID,
                                                ));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'You can review this product only if you have purchased it before.'),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 6.0),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Post',
                                            style: buttonText.copyWith(
                                                fontSize: 14.0),
                                          ),
                                          Icon(
                                            Icons.add,
                                            size: 18.0,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              FutureBuilder(
                                future: db.productsRef
                                    .doc(widget.productID)
                                    .collection('Reviews')
                                    .get(),
                                builder: (context, AsyncSnapshot reviewSnap) {
                                  if (reviewSnap.hasError)
                                    return Container(
                                      child: Center(
                                        child:
                                            Text('Error: ${reviewSnap.error}'),
                                      ),
                                    );
                                  if (reviewSnap.connectionState ==
                                      ConnectionState.done) {
                                    if (!reviewSnap.data.docs.isEmpty)
                                      return ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 12.0,
                                        ),
                                        children: reviewSnap.data.docs
                                            .map<Widget>((reviewDoc) {
                                          Map<String, dynamic> reviewDocData =
                                              reviewDoc.data();
                                          return ReviewCard(
                                            name: reviewDocData['userName'],
                                            review: reviewDocData['review'],
                                            rating: reviewDocData['rating'],
                                          );
                                        }).toList(),
                                      );
                                    else
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                            child: (Text('No reviews yet.'))),
                                      );
                                  }
                                  return Container(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
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
                          StatefulBuilder(
                              builder: (context, StateSetter _setState) {
                            bool productSaved =
                                user.wishlist.contains(widget.productID);
                            return GestureDetector(
                              onTap: () async {
                                if (productSaved) {
                                  user.wishlist.remove(widget.productID);
                                  _setState(() {});
                                  await db.updateUser(user.getUserMap());
                                } else {
                                  user.wishlist.add(widget.productID);
                                  _setState(() {});
                                  await db.updateUser(user.getUserMap());
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 54.0,
                                width: 54.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color:
                                      Theme.of(context).dialogBackgroundColor,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Icon(
                                  productSaved
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 32.0,
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () async {
                              Map<String, dynamic> productMap = {
                                'id': widget.productID,
                                'size': _selectedProductSize
                              };
                              user.cart.add(productMap);
                              await db.updateUser(user.getUserMap());
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Product added to cart')));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 54.0,
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Theme.of(context).primaryColor,
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
                                    "Add to Cart",
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
              }
              //Loading
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 56.0, left: 20.0),
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.15),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: Offset(5, 5))
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                size: 20.0,
                color: Color(0xFF000000).withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

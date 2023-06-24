import 'package:aponline/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aponline/services/db_service.dart';

import '../constants.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final db = DatabaseService();
  bool search = false;

  var queryResultSet = [];

  var tempSearchStore = [];

  initiateSearch(value) async {
    if (value.length == 0) {
      setState(() {
        search = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
    } else
      setState(() {
        search = true;
      });

    // var capitalizedValue =
    //     value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      await db.searchProductByName(value).then((QuerySnapshot products) {
        for (int i = 0; i < products.size; i++) {
          queryResultSet.add(products.docs[i]);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((products) {
        if (products
                .data()['name']
                .toLowerCase()
                .contains(value.toLowerCase()) ==
            true) {
          if (products
                  .data()['name']
                  .toLowerCase()
                  .indexOf(value.toLowerCase()) ==
              0) {
            setState(() {
              tempSearchStore.add(products);
            });
          }
        }
      });
    }

    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 20.0),
            padding: EdgeInsets.only(left: 20.0),
            height: 50.0,
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.1),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: Offset(7, 7))
                ]),
            child: Row(
              children: [
                Icon(Icons.search, color: Theme.of(context).disabledColor),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    onChanged: (text) {
                      initiateSearch(text);
                    },
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for shoes',
                        hintStyle:
                            TextStyle(color: Theme.of(context).disabledColor),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 0.0,
                        )),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: search && queryResultSet.isNotEmpty,
            child: Expanded(
              child: GridView.count(
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 32.0,
                crossAxisCount: 2,
                padding: EdgeInsets.only(
                    bottom: 24.0, top: 12.0, right: 10.0, left: 10.0),
                shrinkWrap: true,
                children: tempSearchStore.map((productDoc) {
                  Map<String, dynamic> productData = productDoc.data();
                  return ProductCard(
                    id: productDoc.id,
                    name: productData['name'],
                    desc: productData['desc'],
                    type: productData['type'],
                    price: productData['price'],
                    images: productData['images'],
                  );
                }).toList(),
              ),
            ),
          ),
          Visibility(
            visible: search && queryResultSet.isEmpty,
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              child: Center(
                  child: Text(
                'No results found.',
                style: greyText,
              )),
            ),
          ),
          Visibility(
            visible: !search,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sneakers',
                            style: headingText.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.productsRef
                                .where('type', isEqualTo: 'sneakers')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        snapshot.data.docs.map((productDoc) {
                                      Map<String, dynamic> productData =
                                          productDoc.data();
                                      return ProductCard(
                                        id: productDoc.id,
                                        name: productData['name'],
                                        desc: productData['desc'],
                                        type: productData['type'],
                                        price: productData['price'],
                                        images: productData['images'],
                                      );
                                    }).toList(),
                                  ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sandals',
                            style: headingText.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.productsRef
                                .where('type', isEqualTo: 'sandals')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        snapshot.data.docs.map((productDoc) {
                                      Map<String, dynamic> productData =
                                          productDoc.data();
                                      return ProductCard(
                                        id: productDoc.id,
                                        name: productData['name'],
                                        desc: productData['desc'],
                                        type: productData['type'],
                                        price: productData['price'],
                                        images: productData['images'],
                                      );
                                    }).toList(),
                                  ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Formal shoes',
                            style: headingText.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.productsRef
                                .where('type', isEqualTo: 'formal')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        snapshot.data.docs.map((productDoc) {
                                      Map<String, dynamic> productData =
                                          productDoc.data();
                                      return ProductCard(
                                        id: productDoc.id,
                                        name: productData['name'],
                                        desc: productData['desc'],
                                        type: productData['type'],
                                        price: productData['price'],
                                        images: productData['images'],
                                      );
                                    }).toList(),
                                  ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Casual shoes',
                            style: headingText.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.productsRef
                                .where('type', isEqualTo: 'casual')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        snapshot.data.docs.map((productDoc) {
                                      Map<String, dynamic> productData =
                                          productDoc.data();
                                      return ProductCard(
                                        id: productDoc.id,
                                        name: productData['name'],
                                        desc: productData['desc'],
                                        type: productData['type'],
                                        price: productData['price'],
                                        images: productData['images'],
                                      );
                                    }).toList(),
                                  ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biker boots',
                            style: headingText.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24.0),
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: db.productsRef
                                .where('type', isEqualTo: 'biker')
                                .get(),
                            builder: (context, snapshot) {
                              // Snap error
                              if (snapshot.hasError)
                                return Text('ErrorL ${snapshot.error}');

                              //Snap connected
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 220.0,
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        bottom: 24.0, top: 12.0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        snapshot.data.docs.map((productDoc) {
                                      Map<String, dynamic> productData =
                                          productDoc.data();
                                      return ProductCard(
                                        id: productDoc.id,
                                        name: productData['name'],
                                        desc: productData['desc'],
                                        type: productData['type'],
                                        price: productData['price'],
                                        images: productData['images'],
                                      );
                                    }).toList(),
                                  ),
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

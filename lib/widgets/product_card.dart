import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/screens/product_screen.dart';

import '../constants.dart';

//Small Trek Card
class ProductCard extends StatelessWidget {
  final String id, name, desc, type;
  final List images;
  final int price;
  final double rating;

  ProductCard(
      {this.id,
      this.name,
      this.desc,
      this.type,
      this.images,
      this.price,
      this.rating = 4.5});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final oldPrice = (price * 1.2).toInt();

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
        margin: EdgeInsets.only(right: 20.0),
        height: 182.0,
        width: 135.0,
        decoration: BoxDecoration(
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
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(images[0]))),
                height: 120.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                color: Colors.white,
                height: 62.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: cardText,
                      ),
                      Text(
                        '₹$oldPrice',
                        style: greyText.copyWith(
                            fontSize: 11.0,
                            decoration: TextDecoration.lineThrough),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹$price',
                            style: highlightText,
                          ),
                          Icon(
                            Icons.check_circle_rounded,
                            size: 15.0,
                            color: Theme.of(context).accentColor,
                          )
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:aponline/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/services/db_service.dart';

import '../constants.dart';

class OrdersScreen extends StatelessWidget {
  final DatabaseService db = DatabaseService();
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 56.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0),
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.15),
                            spreadRadius: 1.0,
                            blurRadius: 8.0,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Your ',
                      style: headingText.copyWith(fontSize: 32.0),
                      children: [
                        TextSpan(
                            text: 'orders',
                            style:
                                TextStyle(color: Theme.of(context).accentColor))
                      ]),
                ),
              ],
            ),
            Consumer<User>(builder: (context, user, child) {
              List orders = user.orders;
              if (orders.isNotEmpty) {
                List<Widget> orderCards = [];
                for (Map order in orders) {
                  orderCards.add(ChangeNotifierProvider.value(
                      value: user, child: OrderCard(order: order)));
                }

                return SingleChildScrollView(
                  child: Column(
                    children: orderCards,
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 3)),
                  child: Center(
                    child: Text(
                      'You have no bookings.',
                      style: greyText,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

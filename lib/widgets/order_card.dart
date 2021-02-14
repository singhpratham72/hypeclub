import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/services/db_service.dart';

import '../constants.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    @required this.order,
  });
  final Map order;
  final DatabaseService db = DatabaseService();
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => Container(
        margin: EdgeInsets.only(right: 20.0, top: 24.0),
        height: 132.0,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://assets.ajio.com/medias/sys_master/root/20201030/KpdZ/5f9c2e61f997dd8c837fd59d/-473Wx593H-460757243-navy-MODEL.jpg'))),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID: ${order['orderID']}',
                          style: greyText.copyWith(fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Icon(
                          Icons.call_made_rounded,
                          size: 22.0,
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                    Text('Items: ${order['items'].length}'),
                    Text(
                      '₹${order['price']}.0',
                      style: highlightText.copyWith(fontSize: 18.0),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Theme.of(context).accentColor,
                              size: 22.0,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '${dateFormat.format(order['orderDate'].toDate())}',
                              style: headingText.copyWith(
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

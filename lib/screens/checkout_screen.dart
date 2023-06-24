import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aponline/models/order.dart';
import 'package:aponline/models/user.dart';
import 'package:aponline/services/db_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

enum PaymentMethod { credit, debit }

class CheckoutBottomSheet extends StatefulWidget {
  CheckoutBottomSheet({
    @required this.cartTotal,
  });
  final int cartTotal;

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  DatabaseService db = DatabaseService();
  int pageSelector = 0;
  List<String> nameList = [];
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  var uuid = Uuid();
  PaymentMethod _paymentMethod = PaymentMethod.credit;
  bool _checkout = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Consumer<Order>(builder: (context, order, child) {
      if (pageSelector == 0)
      // Enter Address
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.0,
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    iconSize: 18.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 18.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Delivery ',
                      style: headingText.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24.0),
                      children: [
                        TextSpan(
                            text: 'Address',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    controller: address,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Address 1",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).disabledColor,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      if (address.text.length == 1)
                        setState(() {});
                      else if (address.text.isEmpty) setState(() {});
                    },
                  )),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    enabled: address.text.isNotEmpty,
                    controller: city,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Address 2",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).disabledColor,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      if (city.text.length == 1)
                        setState(() {});
                      else if (city.text.isEmpty) setState(() {});
                    },
                  )),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(
                    controller: pincode,
                    enabled: city.text.isNotEmpty,
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Pin Code",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).disabledColor,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      if (pincode.text.length == 1)
                        setState(() {});
                      else if (pincode.text.isEmpty) setState(() {});
                    },
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    String newAddress =
                        address.text + ', ' + city.text + ', ' + pincode.text;
                    if (address.text.isNotEmpty) {
                      order.updateAddress(newAddress);
                      order.updatePrice(widget.cartTotal);
                      setState(() {
                        pageSelector = 1;
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: address.text.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "Proceed",
                      style: buttonText.copyWith(fontSize: 20.0),
                    ),
                  )),
            ),
          ],
        );
      } else
      // Checkout
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.0,
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    iconSize: 18.0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 18.0,
                    ),
                    onPressed: () {
                      setState(() {
                        pageSelector = 0;
                      });
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: 'Confirm ',
                      style: headingText.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24.0),
                      children: [
                        TextSpan(
                            text: 'and pay.',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, top: 12.0, bottom: 16.0),
              child: RichText(
                text: TextSpan(
                    text: 'Total: ',
                    style: headingText.copyWith(
                        color: Colors.black, fontSize: 24.0),
                    children: [
                      TextSpan(
                          text: '₹${order.price}.0',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor))
                    ]),
              ),
            ),
            Column(
              children: [
                RadioListTile<PaymentMethod>(
                  dense: true,
                  title: Text(
                    'Pay with Credit Card',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  value: PaymentMethod.credit,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                RadioListTile<PaymentMethod>(
                  dense: true,
                  title: Text(
                    'Pay with Debit Card',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  value: PaymentMethod.debit,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                )
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _checkout = true;
                    });
                    String bookingUID =
                        'IN' + uuid.v1().toUpperCase().substring(25, 32);
                    order.updateID(bookingUID);
                    order.updateDate();
                    order.updateItems(user.cart);
                    Map<String, dynamic> orderMap = order.getOrderMap();
                    user.orders.add(orderMap);
                    await db.updateUser(user.getUserMap());
                    print(user.orders);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Your order has been successfully placed.'),
                    ));
                    user.cart = [];
                    await db.updateUser(user.getUserMap());
                    print(user.orders);
                    setState(() {
                      _checkout = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: address.text.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: _checkout
                        ? Container(
                            height: 26.0,
                            width: 26.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text(
                            "Checkout",
                            style: buttonText.copyWith(fontSize: 20.0),
                          ),
                  )),
            ),
          ],
        );
      }
    });
  }
}

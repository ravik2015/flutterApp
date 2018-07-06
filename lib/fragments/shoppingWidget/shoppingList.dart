import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firstapp/fragments/shoppingWidget/product.dart';
import 'package:firstapp/fragments/shoppingWidget/shoppingItemList.dart';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.product}) : super(key: key);

  List<Product> product;

  @override
  _ShoppingListState createState() {
    return new _ShoppingListState();
  }
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      padding: new EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Expanded(
              child: new ListView(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            children: widget.product.map((Product product) {
              return new ShoppingItemList(product);
            }).toList(),
          )),
          // new RaisedButton(
          //   onPressed: () {
          //     for (Product p in widget.product) {
          //       if (p.isCheck) print(p.name);
          //     }
          //   },
          //   child: new Text('Save'),
          // )
        ],
      ),
    ));
  }
}

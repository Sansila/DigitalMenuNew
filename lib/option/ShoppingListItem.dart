import 'package:flutter/material.dart';
import 'package:appdigitalmenu/option/Product.dart';


class ShoppingItemList extends StatefulWidget{

  final Product product;

  ShoppingItemList(Product product)
      : product = product,
        super(key: new ObjectKey(product));

  @override
  ShoppingItemState createState() {
    return new ShoppingItemState(product);
  }
}
class ShoppingItemState extends State<ShoppingItemList> {

  final Product product;

  ShoppingItemState(this.product);


  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap:null,
        leading: new CircleAvatar(
          backgroundColor: Colors.blue,
          child: new Text(product.avatarImage,style: new TextStyle(fontSize: 16.0),),
        ),
        title: new Row(
          children: <Widget>[
            new Expanded(child: new Text(product.name, style: new TextStyle(fontSize: 12.0,fontFamily: "Khmer"),)),
            new Checkbox(
              value: product.isCheck, 
              onChanged: (bool value){
                setState(() {
                  product.isCheck = value;
                });
              },
            ),
          ],
        )
    );
  }
}
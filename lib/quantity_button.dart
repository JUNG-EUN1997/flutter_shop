import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'salad.dart';

class QuantityButton extends StatefulWidget {
  final Salad salad;
  final Function(int) onQuantityChanged;
  QuantityButton({required this.salad, required this.onQuantityChanged});

  @override
  _QuantityButtonState createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int quantity = 0;

  void increment() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity);
    });
  }

  void decrement() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        widget.onQuantityChanged(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: decrement,
        ),
        Text('$quantity'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: increment,
        ),
      ],
    );
  }
}

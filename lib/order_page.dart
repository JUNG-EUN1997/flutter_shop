// order_page.dart
import 'package:flutter/material.dart';
import 'salad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderPage extends StatefulWidget {
  final List<Salad> salads;

  OrderPage({Key? key, required this.salads}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();

}

class _OrderPageState extends State<OrderPage> {
  Future<void> sendOrder() async {
    final items = widget.salads
        .where((salad) => salad.quantity > 0)
        .map((salad) => {
      'item': salad.name,
      'quantity': salad.quantity,
      'ingredients': salad.ingredients,
    }).toList();

    final order = {
      'name': 'Your Name',  // Replace 'Your Name' with the actual order name
      'items': items,
    };

    final response = await http.post(
      Uri.parse('http://192.168.159.5:3000/order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Order sent successfully');
      // Navigate back to the menu page after order is sent
      Navigator.pop(context);
    } else {
      print('Failed to send order');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Salad> orderedSalads = widget.salads.where((salad) => salad.quantity > 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: ListView.builder(
        itemCount: orderedSalads.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(orderedSalads[index].image),
            title: Text(orderedSalads[index].name),
            subtitle: Text('\$${orderedSalads[index].price.toStringAsFixed(2)} x ${orderedSalads[index].quantity}'),
            trailing: Text('\$${(orderedSalads[index].price * orderedSalads[index].quantity).toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendOrder,
        tooltip: 'Send Order',
        child: Icon(Icons.send),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'quantity_button.dart';
import 'salad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_salad.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Salad> salads = [
    Salad(name: 'Greek Salad', price: 8.99, image: 'assets/greek_salad.jpg'),
    Salad(name: 'Caesar Salad', price: 7.99, image: 'assets/caesar_salad.jpg'),
    Salad(name: 'Custom', price: 9.99, image: 'assets/custom.jpg', isCustom: true),
    // Add other salad items
  ];

  Future<void> sendOrder() async {
    final items = salads.map((salad) => {
      'item': salad.name,
      'quantity': salad.quantity,
      // 'price': salad.price,  // 불필요
      'ingredients': salad.ingredients,  // Adding ingredients field
    }).toList();

    final order = {
      'name': 'Your Name',  // Replace 'Your Name' with the actual order name
      'items': items,
    };

    final response = await http.post(
      Uri.parse('http://localhost:3000/order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Order sent successfully');
    } else {
      print('Failed to send order');
    }
  }

  void handleQuantityChanged(int index, int quantity) {
    setState(() {
      salads[index].quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView.builder(
        itemCount: salads.length,
        itemBuilder: (context, index) {
          if (salads[index].isCustom) {
            return CustomSaladItem(salad: salads[index]);
          } else {
            return ListTile(
              leading: Image.asset(salads[index].image),
              title: Text(salads[index].name),
              subtitle: Text('\$${salads[index].price.toStringAsFixed(2)}'),
              trailing: Container(
                width: 100, // Set the desired width
                child: QuantityButton(
                  salad: salads[index],
                  onQuantityChanged: (int quantity) {
                    handleQuantityChanged(index, quantity);
                  },
                ),
              ),
            );
          }
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

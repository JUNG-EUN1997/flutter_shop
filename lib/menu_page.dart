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
  List<Salad> salads = [];

  Future<void> fetchMenus() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/menu')); // Replace with your actual API endpoint
    if (response.statusCode == 200) {
      final List menus = jsonDecode(response.body);
      setState(() {
        salads = menus.map((menu) =>
            Salad(
              name: menu['name'],
              price: double.tryParse(menu['price'].toString()) ?? 0.0,
              image: menu['imagePath'],
              isCustom: menu['name'] == 'custom', // Add this line
            )).toList();
      });
    } else {
      print('Failed to load menus');
    }
  }

    @override
  void initState() {
    super.initState();
    fetchMenus();
  }

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
              leading: Image.network(salads[index].image),
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

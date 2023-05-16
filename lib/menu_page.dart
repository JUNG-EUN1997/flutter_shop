import 'package:flutter/material.dart';
import 'quantity_button.dart';
import 'salad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_salad.dart';
import 'order_page.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Salad> salads = [];

  Future<void> fetchMenus() async {
    final response = await http.get(Uri.parse(
        'http://192.168.159.5:3000/menu')); // Replace with your actual API endpoint
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
              leading: Image.network(
                salads[index].image,
                // Fix the image URL
                width: 50, // Set a fixed width for the image
                height: 50, // Set a fixed height for the image
                fit: BoxFit.cover, // This could help to prevent overflow
              ),
              title: Text(salads[index].name),
              subtitle: Text('\$${salads[index].price.toStringAsFixed(2)}'),
              trailing: Container(
                width: 80,
                // Reduce the width of the trailing widget to prevent overflow
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderPage(salads: salads)),
          );
        },
        tooltip: 'Checkout',
        child: Icon(Icons.check),
      ),
    );
  }
}
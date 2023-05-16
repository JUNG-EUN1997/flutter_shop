import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final String name;
  final List<Map<String, dynamic>> items;

  Order({required this.name, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      items: List<Map<String, dynamic>>.from(json['items']),
    );
  }
}

Future<List<Order>> fetchOrders() async {
  final response = await http.get(Uri.parse('http://192.168.159.5:3000/order'));

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((order) => Order.fromJson(order)).toList();
  } else {
    throw Exception('Failed to load orders');
  }
}

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: fetchOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data![index].name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(color: Colors.grey),
                      ...snapshot.data![index].items.map((item) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          title: Text(
                            '${item['item']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantity: ${item['quantity'].toString()}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: List<Widget>.generate(
                                    item['ingredients'].length, (int index) {
                                  return Chip(
                                    label: Text(
                                        item['ingredients'][index],
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.green,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}

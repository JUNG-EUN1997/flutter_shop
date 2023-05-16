import 'package:flutter/material.dart';
import 'salad.dart';
import 'quantity_button.dart';
import 'ingredients.dart';

class CustomSaladItem extends StatefulWidget {
  final Salad salad;

  CustomSaladItem({required this.salad});

  @override
  _CustomSaladItemState createState() => _CustomSaladItemState();
}

class _CustomSaladItemState extends State<CustomSaladItem> {
  List<String> selectedIngredients = [];

  void handleQuantityChanged(int quantity) {
    setState(() {
      widget.salad.quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Image.network(
        widget.salad.image,
        // Fix the image URL
        width: 50, // Set a fixed width for the image
        height: 50, // Set a fixed height for the image
        fit: BoxFit.cover, // This could help to prevent overflow
      ),
      title: Text(widget.salad.name),
      subtitle: Text('\$${widget.salad.price.toStringAsFixed(2)}'),
      trailing: Container(
        width: 80,
        child: QuantityButton(
          salad: widget.salad,
          onQuantityChanged: handleQuantityChanged,
        ),
      ),
      children: <Widget>[
        ListTile(
          title: Text('Ingredients'),
          subtitle: Wrap(
            spacing: 8,
            children: <Widget>[
              IngredientItem(
                ingredientImage: 'assets/lettuce.jpg',
                ingredientName: 'Lettuce',
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedIngredients.add('Lettuce');
                    } else {
                      selectedIngredients.remove('Lettuce');
                    }
                    widget.salad.ingredients = selectedIngredients;
                  });
                },
              ),
              IngredientItem(
                ingredientImage: 'assets/kale.jpg',
                ingredientName: 'Kale',
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedIngredients.add('Kale');
                    } else {
                      selectedIngredients.remove('Kale');
                    }
                  });
                },
              ),
              // Add more ingredient items here
            ],
          ),
        ),
      ],
    );
  }
}

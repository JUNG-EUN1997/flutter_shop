import 'package:flutter/material.dart';

class IngredientItem extends StatefulWidget {
  final String ingredientImage;
  final String ingredientName;
  final Function(bool) onSelected;

  IngredientItem({
    required this.ingredientImage,
    required this.ingredientName,
    required this.onSelected,
  });

  @override
  _IngredientItemState createState() => _IngredientItemState();
}

class _IngredientItemState extends State<IngredientItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onSelected(isSelected);
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.ingredientImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            widget.ingredientName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

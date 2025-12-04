import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coffee.dart';
import '../screens/coffee_detail_screen.dart';
import '../providers/favorites_provider.dart'; 

class CoffeeItemCard extends StatelessWidget {
  final Coffee coffee;

  const CoffeeItemCard({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(coffee.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(coffee.imageUrl),
        ),
        title: Text(coffee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Harga Dasar: Rp ${coffee.price.toStringAsFixed(2)}'),
        trailing: Icon(
          isFav ? Icons.favorite : Icons.arrow_forward_ios,
          color: isFav ? Colors.red : Colors.brown,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CoffeeDetailScreen(coffee: coffee),
            ),
          );
        },
      ),
    );
  }
}
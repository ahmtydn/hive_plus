import 'package:flutter/material.dart';
import 'package:hive_plus_secure/hive_plus_secure.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.init(
    getDirectory: () async {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    },
  );
  runApp(BeeApp());
}

class BeeApp extends StatelessWidget {
  const BeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bee Favorites',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: FavoriteFlowers(),
    );
  }
}

class FavoriteFlowers extends StatefulWidget {
  const FavoriteFlowers({super.key});

  @override
  State<FavoriteFlowers> createState() => _FavoriteFlowersState();
}

class _FavoriteFlowersState extends State<FavoriteFlowers> {
  final Box<String> favoriteBox = Hive.box<String>(name: 'favorites');

  final List<String> flowers = ['Rose', 'Tulip', 'Daisy', 'Lily', 'Sunflower'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bee Favorites 🐝')),
      body: ListView.builder(
        itemCount: flowers.length,
        itemBuilder: (context, index) {
          final flower = flowers[index];
          return ListTile(
            title: Text(flower),
            trailing: IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                favoriteBox.add(flower);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$flower added to favorites! 🌼')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.view_list),
        onPressed: () {
          final favorites = favoriteBox.getRange(0, favoriteBox.length);
          showDialog(
            context: context,
            builder: (context) => FavoritesDialog(favorites: favorites),
          );
        },
      ),
    );
  }
}

class FavoritesDialog extends StatelessWidget {
  final List<String> favorites;

  const FavoritesDialog({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bee Favorites 🌼'),
      content: SizedBox(
        width: 300,
        height: 200,
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(favorites[index]));
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

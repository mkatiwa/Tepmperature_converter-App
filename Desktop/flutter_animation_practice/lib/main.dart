import 'package:flutter/material.dart';
import 'product.dart';
import 'theme.dart';

void main() {
  runApp(const FlutterStoreApp());
}

class FlutterStoreApp extends StatefulWidget {
  const FlutterStoreApp({super.key});

  @override
  _FlutterStoreAppState createState() => _FlutterStoreAppState();
}

class _FlutterStoreAppState extends State<FlutterStoreApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Store',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Use a valid MaterialColor
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CatalogPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode), // home should be outside theme
    );
  }
}

class CatalogPage extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const CatalogPage({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Store'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => toggleTheme(),
          ),
        ],
      ),
      body: const ProductGrid(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductCard(products[i]),
    );
  }
}

// Remove the duplicate StatelessWidget version of ProductCard
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard(this.product, {super.key});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${widget.product.name}')),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: EdgeInsets.all(isTapped ? 15 : 10),
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Image.network(
                widget.product.imageUrl,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Error handling
                },
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
              Text(widget.product.name, style: const TextStyle(fontSize: 16)),
              Text('\$${widget.product.price}', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({required this.name, required this.imageUrl, required this.price});
}

List<Product> products = [
  Product(name: 'Product 1', imageUrl: '', price: 29.99),
  Product(name: 'Product 2', imageUrl: '', price: 49.99),
  // Add more products here
];

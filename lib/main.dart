import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Store',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PaymentPage(),
    );
  }
}

class Product {
  final String name;
  final int point;
  final double price;

  Product({required this.name, required this.point, required this.price});
}
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<Product> products = [
    Product(name: "ฟองเต้าหู้ทอด",point: 1, price: 10),
    Product(name: "ไส้กรอก",point: 1, price: 15),
    Product(name: "เห็ดเข็มทองพันเบคอน",point:2, price: 20),
    Product(name: "เบคอนพันไส้กรอก",point:2, price: 25),
  ];

  final Map<String, int> cart = {};

  double get totalPrice {
    double total = 0;
    for (var product in products) {
      if (cart.containsKey(product.name)) {
        total += product.price * cart[product.name]!;
      }
    }
    return total;
  }

  int userPoint = 0;

  int get totalPoint {
    int total = 0;

    for (var product in products) {
      if (cart.containsKey(product.name)) {
        total += product.point * cart[product.name]!;
      }
    }

    return total;
  }

  void addToCart(Product product) {
    setState(() {
      cart.update(product.name, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void removeFromCart(String productName) {
    setState(() {
      if (cart.containsKey(productName)) {
        if (cart[productName]! > 1) {
          cart[productName] = cart[productName]! - 1;
        } else {
          cart.remove(productName);
        }
      }
    });
  }

  void checkout() {
    setState(() {
      userPoint += totalPoint;
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ระบบชำระเงินร้านหมาล่า"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Text(
                "แต้ม: $userPoint",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(product.name,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text("${product.price} บาท"),
                        const SizedBox(height: 8),
                        Text(
                          "จำนวน: ${cart[product.name] ?? 0}",
                          style: const TextStyle(color: Colors.green),
                        ),
                        Row (
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                addToCart(product);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                removeFromCart(product.name);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ราคารวม: ${totalPrice.toStringAsFixed(0)} บาท",
                  style: const TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: checkout,
                  child: const Text("ชำระเงิน"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

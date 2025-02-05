import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  static List<Map> cartItems = []; // Static list to hold cart items

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double calculateSubtotal() {
    return CartScreen.cartItems.fold(0, (sum, item) {
      // Ensure price is parsed as double
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = calculateSubtotal();

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: CartScreen.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty!'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: CartScreen.cartItems.length,
              itemBuilder: (context, index) {
                var item = CartScreen.cartItems[index];
                return ListTile(
                  leading: Image.network(
                    item['product_image'],
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item['name']),
                  subtitle: Text('LKR ${item['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        CartScreen.cartItems.removeAt(index); // Remove item from cart
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} removed from cart')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal:', style: TextStyle(fontSize: 16)),
                    Text('LKR ${subtotal.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutScreen(subtotal: subtotal)),
                      );
                    },
                    child: Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

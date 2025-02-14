import 'package:damh/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_scaffold.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  void showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: const Text('You have purchased the products'),
          actions: [
            TextButton(
              onPressed: () {
                // Clear all items in the cart
                Provider.of<CartProvider>(context, listen: false).clearCart();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem> cartItems = Provider.of<CartProvider>(context).cartItems;
    return CustomScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CART',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: ((context, index) {
                    CartItem item = cartItems[index];
                    return Dismissible(
                      key: Key(item.name),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        Provider.of<CartProvider>(context, listen: false).removeItem(index);
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.cancel, color: Colors.white),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              item.image,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Provider.of<CartProvider>(context, listen: false).decrementQuantity(index);
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<CartProvider>(context, listen: false).incrementQuantity(index);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      'Cart Total: ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(width: 50.0),
                    Text(
                      '\$${Provider.of<CartProvider>(context).getCartTotal().toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: showCheckoutDialog,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      showBottomNavBar: true,
      initialIndex: 3,
    );
  }
}

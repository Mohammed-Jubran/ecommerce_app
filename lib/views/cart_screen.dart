import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/views/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    getCartItems();
    super.initState();
  }

  getCartItems() async {
    await Provider.of<CartProvider>(context, listen: false).getCart();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartTotalAmount =
        Provider.of<CartProvider>(context, listen: false).cartTotalAmount;
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping cart')),
      bottomNavigationBar: SizedBox(
        height: 130,
        child: Card(
          shadowColor: Colors.purple,
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total amount:',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${cartTotalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CheckOutScreen()));
                        },
                        child: const Text('CHECKOUT')))
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<CartProvider>(builder: (context, value, child) {
              return ListView.builder(
                  itemCount: value.cartItems.length,
                  itemBuilder: (context, index) => ListTile(
                        leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        value.cartItems[index].imageUrl)))),
                        title: Text(
                          value.cartItems[index].name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('x${value.cartItems[index].count}'),
                            Text('\$${value.cartItems[index].price}',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ));
            }),
    );
  }
}

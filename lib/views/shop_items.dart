import 'package:ecommerce_app/models/item.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/item_provider.dart';
import 'package:ecommerce_app/views/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopItems extends StatefulWidget {
  final String shopName;
  final int id;
  const ShopItems({required this.id, required this.shopName, Key? key})
      : super(key: key);

  @override
  State<ShopItems> createState() => _ShopItemsState();
}

class _ShopItemsState extends State<ShopItems> {
  bool _isLoading = true;
  @override
  void initState() {
    getItems();
    super.initState();
  }

  getItems() async {
    await Provider.of<ItemsProvider>(context, listen: false)
        .getItems(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  _showBottomSheet(int index, List<Item> items) {
    int count = 0;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(items[index].imageUrl, height: 250),
                  ),
                  Text(
                    items[index].name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${items[index].price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          if (count == 0) return;
                          setState(() {
                            --count;
                          });
                          Provider.of<CartProvider>(context, listen: false)
                              .updateCart(
                                  count: count, itemId: items[index].id);
                        },
                        icon: const Icon(Icons.remove, color: Colors.red)),
                    Text('$count'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            ++count;
                          });
                          if (count == 1) {
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(itemId: items[index].id);
                          } else {
                            Provider.of<CartProvider>(context, listen: false)
                                .updateCart(
                                    count: count, itemId: items[index].id);
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.blue)),
                  ]),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ItemsProvider>(builder: (context, value, child) {
              return GridView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: value.items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _showBottomSheet(index, value.items),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(value.items[index].imageUrl,
                              height: 110),
                          Text(
                            value.items[index].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            '\$${value.items[index].price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.red),
                          )
                        ],
                      ),
                    );
                  });
            }),
    );
  }
}

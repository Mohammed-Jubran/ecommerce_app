import 'package:ecommerce_app/providers/home_screen_provider.dart';
import 'package:ecommerce_app/views/shop_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCollection extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const CategoryCollection(
      {required this.categoryName, required this.categoryId, Key? key})
      : super(key: key);

  @override
  State<CategoryCollection> createState() => _CategoryCollectionState();
}

class _CategoryCollectionState extends State<CategoryCollection> {
  bool _isLoading = true;

  @override
  void initState() {
    getCategoryCollection();
    super.initState();
  }

  getCategoryCollection() async {
    await Provider.of<HomeScreenProvider>(context, listen: false)
        .getShops(widget.categoryId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('${widget.categoryName} Collection',
            style: const TextStyle(color: Colors.black)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.location_on_outlined),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Search',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50))),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer<HomeScreenProvider>(
                    builder: (context, value, child) {
                    return ListView.builder(
                        itemCount: value.shops.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            value.shops[index].imageUrl)))),
                            title: Text(
                              value.shops[index].name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopItems(
                                            id: index + 1,
                                            shopName:
                                                value.shops[index].name)));
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          );
                        });
                  }),
          ),
        ],
      ),
    );
  }
}

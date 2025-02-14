import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'custom_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class CardItem {
  final String title;
  final String pricing;
  final List<String> images;
  int currentIndex;

  CardItem({
    required this.title,
    required this.pricing,
    required this.images,
    this.currentIndex = 0,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardItem> cardItems = [];
  List<CardItem> filteredItems = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchProductsFromFirestore();
  }

  /// Fetch data from Firestore
  void fetchProductsFromFirestore() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Homeimage').get();

    final List<CardItem> fetchedItems = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return CardItem(
        title: data['title'] ?? '',
        pricing: data['price'] ?? '',
        images: [
          data['url1'] ?? '',
          data['url2'] ?? '',
          data['url3'] ?? '',
        ],
      );
    }).toList();

    if (mounted) {
      setState(() {
        cardItems = fetchedItems;
        filteredItems = fetchedItems;
      });
    }
  }

  void updateCurrentIndex(CardItem cardItem, int newIndex) {
    setState(() {
      cardItem.currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: CustomScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.orange[700]),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search shoe, clothing & sock',
                            hintStyle:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                              filteredItems = cardItems
                                  .where((cardItem) => cardItem.title
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.filter_list),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return buildCard(
                      context,
                      filteredItems[index],
                      (newIndex) {
                        updateCurrentIndex(filteredItems[index], newIndex);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        showBottomNavBar: true,
        initialIndex: 0,
      ),
    );
  }
}

Widget buildCard(
    BuildContext context, CardItem cardItem, Function(int) onPageChanged) {
  return GestureDetector(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetail(cardItem: cardItem)),
      );
    },
    child: Card(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: PageView.builder(
              itemCount: cardItem.images.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Bo góc hình ảnh
                  child: Image.network(
                    cardItem.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              cardItem.images.length,
              (int circleIndex) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: circleIndex == cardItem.currentIndex
                        ? Colors.blue
                        : Colors.grey,
                  ),
                );
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            title: Text(
              cardItem.title,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              '\$${cardItem.pricing}',
              style: TextStyle(color: Colors.red),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Premium',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

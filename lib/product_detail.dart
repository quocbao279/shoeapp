import 'package:carousel_slider/carousel_slider.dart';
import 'package:damh/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class ProductDetail extends StatefulWidget {
  final CardItem cardItem; // Dữ liệu sản phẩm được truyền từ màn hình trước.

  const ProductDetail({required this.cardItem, super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _currentSlide = 0;
  int selectedButton = 2;

  void addToCart() {
  double parsedPrice = 0.0;

  // Safely parse the price string to double
  try {
    parsedPrice = double.parse(widget.cardItem.pricing);
  } catch (e) {
    // If parsing fails, log an error and use a default value
    debugPrint("Failed to parse price: ${widget.cardItem.pricing}");
    parsedPrice = 0.0; // Default to 0 if parsing fails
  }

  CartItem newItem = CartItem(
    name: widget.cardItem.title,
    price: parsedPrice,
    quantity: 1,
    image: widget.cardItem.images.isNotEmpty ? widget.cardItem.images[0] : '',
  );
  Provider.of<CartProvider>(context, listen: false).addToCart(newItem);

  // Hiển thị thông báo Snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${widget.cardItem.title} added to cart!'),
      duration: Duration(seconds: 2),
    ),
  );
}


  void selectButton(int buttonIndex) {
    setState(() {
      selectedButton = buttonIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              onPageChanged: (index, _) {
                setState(() {
                  _currentSlide = index;
                });
              },
            ),
            items: widget.cardItem.images.map((image) {
              return Builder(
                builder: (context) {
                  return Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.cardItem.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      '\$${widget.cardItem.pricing}',
                      style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              'Product Description',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• High-quality materials',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '• Comfortable design',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '• Perfect for everyday wear',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      selectButton(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedButton == 1 ? Colors.orange : Colors.white,
                    ),
                    child: Text(
                      'ReSell',
                      style: TextStyle(
                        color:
                            selectedButton == 1 ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      selectButton(2);
                      addToCart();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedButton == 2 ? Colors.orange : Colors.white,
                    ),
                    child: Text(
                      'Add To Cart',
                      style: TextStyle(
                        color:
                            selectedButton == 2 ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
} 
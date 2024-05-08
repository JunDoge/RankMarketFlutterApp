import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/product/ProductDetail.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductDetail product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  CarouselController carouselController = CarouselController();
  late List<ImageProvider> _imageProvider = [];
  bool _isImageLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImage();
  }

  void _loadImage() async {
    for (String image in widget.product.imgs) {
      var imageProvider = NetworkImage('https://rankmarketfile.s3.ap-northeast-2.amazonaws.com/$image');
      await precacheImage(imageProvider, context);
      _imageProvider.add(imageProvider);
    }
    setState(() {
      _isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                selectedImage = index;
              });
            },
          ),
          items: _imageProvider.map((image) {
            return SizedBox(
              width: 238,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image(
                  image: image,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        Container(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageProvider.length,
            itemBuilder: (context, index) => SmallProductImage(
              isSelected: index == selectedImage,
              press: () {
                setState(() {
                  selectedImage = index;
                });
                carouselController.jumpToPage(index);
              },
              image: _imageProvider[index],
            ),
          ),
        ),
      ],
    );
  }
}

class SmallProductImage extends StatefulWidget {
  const SmallProductImage({
    Key? key,
    required this.isSelected,
    required this.press,
    required this.image,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback press;
  final ImageProvider image;

  @override
  State<SmallProductImage> createState() => _SmallProductImageState();
}

class _SmallProductImageState extends State<SmallProductImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kPrimaryColor.withOpacity(widget.isSelected ? 1 : 0),
          ),
        ),
        child: Image(
          image: widget.image,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}


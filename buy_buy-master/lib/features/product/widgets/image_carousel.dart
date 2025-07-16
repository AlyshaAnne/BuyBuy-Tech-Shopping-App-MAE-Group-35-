import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    this.height = 400,
    this.viewportFraction = 0.75,
  });

  final List<String> images;
  final double height;
  final double viewportFraction;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  late final int _initialPage;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();

    final int base = 1000;
    _initialPage = base - (base % widget.images.length);

    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _initialPage,
    );

    _currentPage = _initialPage.toDouble();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _realIndex(int index) => index % widget.images.length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final realIndex = _realIndex(index);
          final scale = (1 - (_currentPage - index).abs()).clamp(0.85, 1.0);

          return Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Material(
                elevation: scale == 1.0 ? 8 : 2,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: double.infinity,
                  height: widget.height,
                  child: Image.network(
                    widget.images[realIndex],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

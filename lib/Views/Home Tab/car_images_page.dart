import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:otobix/Utils/app_images.dart';

class CarImagesPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const CarImagesPage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = initialIndex.obs;
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Obx(
          () => Text(
            '${currentIndex.value + 1} / ${imageUrls.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        pageController: pageController,
        onPageChanged: (index) => currentIndex.value = index,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(imageUrls[index]), //
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(
              tag: 'image-$index',
              transitionOnUserGestures: true,
            ),
            errorBuilder:
                (_, __, ___) => const Center(
                  child: Image(image: AssetImage(AppImages.carAlternateImage)),
                ),
          );
        },
      ),
    );
  }
}

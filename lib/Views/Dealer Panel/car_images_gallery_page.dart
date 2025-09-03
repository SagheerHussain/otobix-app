// lib/screens/sectioned_gallery_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/car_images_gallery_controller.dart';
import 'package:otobix/Models/car_gallery_sections_model.dart';
import 'package:shimmer/shimmer.dart';

class CarImagesGalleryPage extends StatelessWidget {
  const CarImagesGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CarImagesGalleryController());

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: Column(
        children: [
          _ChipsBar(controller: c),
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: c.scrollController,
                padding: EdgeInsets.only(bottom: c.outerPad),
                itemCount: c.sections.length,
                itemBuilder:
                    (_, i) => _SectionBlock(
                      key: c.sectionKeys[c.sections[i].id],
                      controller: c,
                      section: c.sections[i],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipsBar extends StatelessWidget {
  final CarImagesGalleryController controller;
  const _ChipsBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      child: Container(
        key: controller.headerKey,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Obx(
          () => SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: controller.sections.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final isActive = controller.selectedIndex.value == i;
                final title = controller.sections[i].title;
                return GestureDetector(
                  onTap: () => controller.onChipTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? theme.colorScheme.primary.withOpacity(0.12)
                              : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color:
                            isActive
                                ? theme.colorScheme.primary
                                : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isActive
                                  ? theme.colorScheme.primary
                                  : const Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final CarImagesGalleryController controller;
  final CarGallerySectionsModel section;

  const _SectionBlock({
    super.key,
    required this.controller,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final gap = controller.gridGap;
    final cols = controller.gridColumns;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        controller.outerPad,
        6,
        controller.outerPad,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          // Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final columnSizes = List.generate(cols, (_) => 1.fr);
              return LayoutGrid(
                columnSizes: columnSizes,
                rowSizes: List.generate(
                  (section.images.length / cols).ceil(),
                  (_) => auto,
                ),
                columnGap: gap,
                rowGap: gap,
                children: [
                  for (int i = 0; i < section.images.length; i++)
                    _ImageTile(
                      url: section.images[i],
                      onTap: () => controller.openViewer(section, i),
                    ).withGridPlacement(
                      columnStart: i % cols,
                      rowStart: i ~/ cols,
                    ),
                ],
              );
            },
          ),

          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String url;
  final VoidCallback onTap;
  const _ImageTile({required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: const Color(0xFFF2F2F2),
        child: InkWell(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 3 / 4, // portrait-ish
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => Shimmer.fromColors(
                    baseColor: const Color(0xFFE5E7EB),
                    highlightColor: const Color(0xFFF3F4F6),
                    child: Container(color: const Color(0xFFE5E7EB)),
                  ),
              errorWidget:
                  (_, __, ___) => const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
      ),
    );
  }
}

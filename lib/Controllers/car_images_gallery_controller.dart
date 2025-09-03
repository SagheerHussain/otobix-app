// lib/controllers/sectioned_gallery_controller.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/car_gallery_sections_model.dart';

class CarImagesGalleryController extends GetxController {
  final sections = <CarGallerySectionsModel>[].obs;
  final selectedIndex = 0.obs;

  final scrollController = ScrollController();
  final sectionKeys = <String, GlobalKey>{};
  final headerKey = GlobalKey();

  // Config
  final int gridColumns = 3;
  final double gridGap = 12;
  final double outerPad = 16;

  bool _updatingFromTap = false;

  // Deep-link target (from Get.arguments)
  String? initialSectionId;

  @override
  void onInit() {
    super.onInit();
    initialSectionId = Get.arguments?['sectionId'] as String?;
    _seedDemoData(); // replace with your API
    _initKeys();
    scrollController.addListener(_onScrollUpdateActiveChip);
  }

  @override
  void onReady() {
    super.onReady();
    if (initialSectionId != null) {
      final i = sections.indexWhere((s) => s.id == initialSectionId);
      if (i >= 0) {
        // Jump after first frame so sizes are known
        Future.delayed(const Duration(milliseconds: 50), () => onChipTap(i));
      }
    }
  }

  void _seedDemoData() {
    sections.value = [
      CarGallerySectionsModel(
        id: 'exterior',
        title: 'Exterior',
        images: [
          'https://picsum.photos/seed/f1/600/800',
          'https://picsum.photos/seed/f2/600/800',
          'https://picsum.photos/seed/f3/600/800',
          'https://picsum.photos/seed/f4/600/800',
          'https://picsum.photos/seed/f5/600/800',
          'https://picsum.photos/seed/f6/600/800',
        ],
      ),
      CarGallerySectionsModel(
        id: 'engine',
        title: 'Engine',
        images: [
          'https://picsum.photos/seed/n1/600/800',
          'https://picsum.photos/seed/n2/600/800',
          'https://picsum.photos/seed/n3/600/800',
          'https://picsum.photos/seed/n4/600/800',
          'https://picsum.photos/seed/n5/600/800',
          'https://picsum.photos/seed/n6/600/800',
          'https://picsum.photos/seed/n7/600/800',
        ],
      ),
      CarGallerySectionsModel(
        id: 'suspension',
        title: 'Suspension',
        images: [
          'https://picsum.photos/seed/a1/600/800',
          'https://picsum.photos/seed/a2/600/800',
          'https://picsum.photos/seed/a3/600/800',
          'https://picsum.photos/seed/a4/600/800',
          'https://picsum.photos/seed/a5/600/800',
        ],
      ),
      CarGallerySectionsModel(
        id: 'ac',
        title: 'AC',
        images: [
          'https://picsum.photos/seed/p1/600/800',
          'https://picsum.photos/seed/p2/600/800',
          'https://picsum.photos/seed/p3/600/800',
          'https://picsum.photos/seed/p4/600/800',
          'https://picsum.photos/seed/p5/600/800',
          'https://picsum.photos/seed/p6/600/800',
        ],
      ),
      CarGallerySectionsModel(
        id: 'interior',
        title: 'Interior',
        images: [
          'https://picsum.photos/seed/p1/600/800',
          'https://picsum.photos/seed/p2/600/800',
          'https://picsum.photos/seed/p3/600/800',
          'https://picsum.photos/seed/p4/600/800',
          'https://picsum.photos/seed/p5/600/800',
          'https://picsum.photos/seed/p6/600/800',
        ],
      ),
    ];
  }

  void _initKeys() {
    for (final s in sections) {
      sectionKeys[s.id] = GlobalKey(debugLabel: 'section_${s.id}');
    }
  }

  Future<void> onChipTap(int index) async {
    if (index < 0 || index >= sections.length) return;
    selectedIndex.value = index;

    final key = sectionKeys[sections[index].id];
    if (key?.currentContext == null) return;

    _updatingFromTap = true;

    // Smoothly ensure visible
    await Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.02,
    );

    // Nudge for header overlap
    final headerHeight = _getHeaderHeight();
    await Future.delayed(const Duration(milliseconds: 10));
    final offset = max(0.0, scrollController.offset - headerHeight - 8);
    await scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );

    _updatingFromTap = false;
  }

  void _onScrollUpdateActiveChip() {
    if (_updatingFromTap) return;
    final headerHeight = _getHeaderHeight();
    const tolerance = 60.0;

    int best = selectedIndex.value;
    double dist = double.infinity;

    for (var i = 0; i < sections.length; i++) {
      final key = sectionKeys[sections[i].id];
      final ctx = key?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;

      final top = box.localToGlobal(Offset.zero).dy;
      final d = (top - headerHeight).abs();
      if (d < dist) {
        dist = d;
        best = i;
      }
    }

    if (best != selectedIndex.value && dist < tolerance) {
      selectedIndex.value = best;
    }
  }

  double _getHeaderHeight() {
    final ctx = headerKey.currentContext;
    if (ctx == null) return 0;
    final box = ctx.findRenderObject() as RenderBox?;
    return (box?.attached ?? false) ? box!.size.height : 0;
  }

  void openViewer(CarGallerySectionsModel section, int initialIndex) {
    // Get.toNamed(
    //   AppRoutes.viewer,
    //   arguments: {
    //     'images': section.images,
    //     'initialIndex': initialIndex,
    //     'title': section.title,
    //   },
    //   preventDuplicates: false,
    // );
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScrollUpdateActiveChip);
    scrollController.dispose();
    super.onClose();
  }
}

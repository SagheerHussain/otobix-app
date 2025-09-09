import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/car_model.dart';
import 'package:otobix/Utils/app_constants.dart';
import '../Models/car_gallery_sections_model.dart';

class CarImagesGalleryController extends GetxController {
  final CarModel car;
  final String initialSectionId;
  final int initialSectionIndex;

  // Constructor to get car details, initial section id and index
  CarImagesGalleryController(
    this.car,
    this.initialSectionId,
    this.initialSectionIndex,
  );

  // Observables
  final sections = <CarGallerySectionsModel>[].obs;
  final selectedIndex = 0.obs;
  final scrollController = ScrollController();
  final sectionKeys = <String, GlobalKey>{};
  final headerKey = GlobalKey();

  // Configurations
  final int gridColumns = 3;
  final double gridGap = 12;
  final double outerPad = 16;

  bool _updatingFromTap = false;

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = initialSectionIndex;
    _seedDemoData();
    _initKeys();
    scrollController.addListener(_onScrollUpdateActiveChip);
  }

  @override
  void onReady() {
    super.onReady();
    // Handle deep-link navigation to the specific section

    final i = sections.indexWhere((s) => s.id == initialSectionId);
    if (i >= 0) {
      Future.delayed(const Duration(milliseconds: 50), () => onChipTap(i));
    }
  }

  // Seed demo data for car sections (replace with real data from API)
  void _seedDemoData() {
    sections.value = [
      CarGallerySectionsModel(
        id: AppConstants.imagesSectionIds.interior,
        title: 'Interior',
        images: [
          ...car.frontSeatsFromDriverSideDoorOpen,
          ...car.rearSeatsFromRightSideDoorOpen,
          ...car.dashboardFromRearSeat,
        ],
      ),

      CarGallerySectionsModel(
        id: AppConstants.imagesSectionIds.suspension,
        title: 'Suspension',
        images: [
          ...car.lhsFrontAlloyImages,
          ...car.rhsFrontAlloyImages,
          ...car.lhsRearAlloyImages,
          ...car.rhsRearAlloyImages,
          ...car.lhsFrontTyreImages,
          ...car.rhsFrontTyreImages,
          ...car.lhsRearTyreImages,
          ...car.rhsRearTyreImages,
        ],
      ),

      CarGallerySectionsModel(
        id: AppConstants.imagesSectionIds.engine,
        title: 'Engine',
        images: [
          ...car.engineBay,
          ...car.batteryImages,
          // ...car.exhaustSmokeImages,
          ...car.apronLhsRhs,
        ],
      ),

      CarGallerySectionsModel(
        id: AppConstants.imagesSectionIds.exterior,
        title: 'Exterior',
        images: [
          ...car.bonnetImages,
          ...car.frontBumperImages,
          ...car.lhsHeadlampImages,
          ...car.rhsHeadlampImages,
          ...car.frontWindshieldImages,
          ...car.lhsFenderImages,
          ...car.rhsFenderImages,
          ...car.lhsFrontDoorImages,
          ...car.rhsFrontDoorImages,
          ...car.lhsOrvmImages,
          ...car.rhsOrvmImages,
        ],
      ),

      // CarGallerySectionsModel(
      //   id: AppConstants.imagesSectionIds.ac,
      //   title: 'AC',
      //   images: [...car.lhsFrontAlloyImages], // Sample section data
      // ),
    ];
  }

  // Initialize GlobalKeys for each section
  void _initKeys() {
    for (final s in sections) {
      sectionKeys[s.id] = GlobalKey(debugLabel: 'section_${s.id}');
    }
  }

  // Handle chip tap (smooth scroll to section)
  Future<void> onChipTap(int index) async {
    if (index < 0 || index >= sections.length) return;

    _updatingFromTap = true;
    selectedIndex.value = index;

    final key = sectionKeys[sections[index].id];
    if (key?.currentContext == null) return;

    _updatingFromTap = true;

    // Smoothly scroll to the section
    await Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.02,
    );

    // Adjust for header overlap
    final headerHeight = _getHeaderHeight();
    final offset = max(0.0, scrollController.offset - headerHeight - 8);

    await scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );

    _updatingFromTap = false;
  }

  // Track scroll to update active chip
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

  // Get the header height (for offset adjustment)
  double _getHeaderHeight() {
    final ctx = headerKey.currentContext;
    if (ctx == null) return 0;
    final box = ctx.findRenderObject() as RenderBox?;
    return (box?.attached ?? false) ? box!.size.height : 0;
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScrollUpdateActiveChip);
    scrollController.dispose();
    super.onClose();
  }
}

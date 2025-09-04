import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/car_model.dart';
import '../Models/car_gallery_sections_model.dart';

class CarImagesGalleryController extends GetxController {
  final CarModel car; // Car details injected through constructor

  // Constructor to get car details
  CarImagesGalleryController(this.car);

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
  String? initialSectionId; // Deep-link target (from Get.arguments)

  @override
  void onInit() {
    super.onInit();
    initialSectionId = Get.arguments?['sectionId'] as String?;
    _seedDemoData(); // Seed demo data, replace with API
    _initKeys();
    scrollController.addListener(_onScrollUpdateActiveChip);
  }

  @override
  void onReady() {
    super.onReady();
    // Handle deep-link navigation to the specific section
    if (initialSectionId != null) {
      final i = sections.indexWhere((s) => s.id == initialSectionId);
      if (i >= 0) {
        Future.delayed(const Duration(milliseconds: 50), () => onChipTap(i));
      }
    }
  }

  // Seed demo data for car sections (replace with real data from API)
  void _seedDemoData() {
    sections.value = [
      CarGallerySectionsModel(
        id: 'exterior',
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
      CarGallerySectionsModel(
        id: 'engine',
        title: 'Engine',
        images: [
          ...car.engineBay,
          ...car.batteryImages,
          ...car.exhaustSmokeImages,
          ...car.apronLhsRhs,
        ],
      ),
      CarGallerySectionsModel(
        id: 'suspension',
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
      // CarGallerySectionsModel(
      //   id: 'ac',
      //   title: 'AC',
      //   images: [...car.lhsFrontAlloyImages], // Sample section data
      // ),
      CarGallerySectionsModel(
        id: 'interior',
        title: 'Interior',
        images: [
          ...car.frontSeatsFromDriverSideDoorOpen,
          ...car.rearSeatsFromRightSideDoorOpen,
          ...car.dashboardFromRearSeat,
        ],
      ),
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
    print('Section tapped: $index');
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
    print('Header height: $headerHeight');
    final offset = max(0.0, scrollController.offset - headerHeight - 8);
    print('Scrolling to offset: $offset');

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

  void openViewer(CarGallerySectionsModel section, int initialIndex) {
    // Uncomment this to enable gallery viewer navigation
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

// // lib/controllers/sectioned_gallery_controller.dart
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix/Models/car_model.dart';
// import '../Models/car_gallery_sections_model.dart';

// class CarImagesGalleryController extends GetxController {
//   final CarModel car;
//   // constructor to get car details
//   CarImagesGalleryController(this.car);

//   final sections = <CarGallerySectionsModel>[].obs;
//   final selectedIndex = 0.obs;

//   final scrollController = ScrollController();
//   final sectionKeys = <String, GlobalKey>{};
//   final headerKey = GlobalKey();

//   // Config
//   final int gridColumns = 3;
//   final double gridGap = 12;
//   final double outerPad = 16;

//   bool _updatingFromTap = false;

//   // Deep-link target (from Get.arguments)
//   String? initialSectionId;

//   @override
//   void onInit() {
//     super.onInit();
//     initialSectionId = Get.arguments?['sectionId'] as String?;
//     _seedDemoData(); // replace with your API
//     _initKeys();
//     scrollController.addListener(_onScrollUpdateActiveChip);
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     if (initialSectionId != null) {
//       final i = sections.indexWhere((s) => s.id == initialSectionId);
//       if (i >= 0) {
//         // Jump after first frame so sizes are known
//         Future.delayed(const Duration(milliseconds: 50), () => onChipTap(i));
//       }
//     }
//   }

//   void _seedDemoData() {
//     sections.value = [
//       CarGallerySectionsModel(
//         id: 'exterior',
//         title: 'Exterior',
//         images: [
//           ...car.bonnetImages,
//           ...car.frontBumperImages,
//           ...car.lhsHeadlampImages,
//           ...car.rhsHeadlampImages,
//           ...car.frontWindshieldImages,
//           ...car.lhsFenderImages,
//           ...car.rhsFenderImages,
//           ...car.lhsFrontDoorImages,
//           ...car.rhsFrontDoorImages,
//           ...car.lhsOrvmImages,
//           ...car.rhsOrvmImages,
//         ],
//       ),
//       CarGallerySectionsModel(
//         id: 'engine',
//         title: 'Engine',
//         images: [
//           ...car.engineBay,
//           ...car.batteryImages,
//           ...car.exhaustSmokeImages,
//           ...car.apronLhsRhs,
//         ],
//       ),
//       CarGallerySectionsModel(
//         id: 'suspension',
//         title: 'Suspension',
//         images: [
//           ...car.lhsFrontAlloyImages,
//           ...car.rhsFrontAlloyImages,
//           ...car.lhsRearAlloyImages,
//           ...car.rhsRearAlloyImages,
//           ...car.lhsFrontTyreImages,
//           ...car.rhsFrontTyreImages,
//           ...car.lhsRearTyreImages,
//           ...car.rhsRearTyreImages,
//         ],
//       ),
//       CarGallerySectionsModel(
//         id: 'ac',
//         title: 'AC',
//         images: [...car.lhsFrontAlloyImages],
//       ),
//       CarGallerySectionsModel(
//         id: 'interior',
//         title: 'Interior',
//         images: [
//           ...car.frontSeatsFromDriverSideDoorOpen,
//           ...car.rearSeatsFromRightSideDoorOpen,
//           ...car.dashboardFromRearSeat,
//         ],
//       ),
//     ];
//   }

//   void _initKeys() {
//     for (final s in sections) {
//       sectionKeys[s.id] = GlobalKey(debugLabel: 'section_${s.id}');
//     }
//   }

//   Future<void> onChipTap(int index) async {
//     if (index < 0 || index >= sections.length) return;
//     selectedIndex.value = index;

//     final key = sectionKeys[sections[index].id];
//     if (key?.currentContext == null) return;

//     _updatingFromTap = true;

//     // Smoothly ensure visible
//     await Scrollable.ensureVisible(
//       key!.currentContext!,
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeInOut,
//       alignment: 0.02,
//     );

//     // Nudge for header overlap
//     final headerHeight = _getHeaderHeight();
//     await Future.delayed(const Duration(milliseconds: 10));
//     final offset = max(0.0, scrollController.offset - headerHeight - 8);
//     await scrollController.animateTo(
//       offset,
//       duration: const Duration(milliseconds: 180),
//       curve: Curves.easeOut,
//     );

//     _updatingFromTap = false;
//   }

//   void _onScrollUpdateActiveChip() {
//     if (_updatingFromTap) return;
//     final headerHeight = _getHeaderHeight();
//     const tolerance = 60.0;

//     int best = selectedIndex.value;
//     double dist = double.infinity;

//     for (var i = 0; i < sections.length; i++) {
//       final key = sectionKeys[sections[i].id];
//       final ctx = key?.currentContext;
//       if (ctx == null) continue;
//       final box = ctx.findRenderObject() as RenderBox?;
//       if (box == null || !box.attached) continue;

//       final top = box.localToGlobal(Offset.zero).dy;
//       final d = (top - headerHeight).abs();
//       if (d < dist) {
//         dist = d;
//         best = i;
//       }
//     }

//     if (best != selectedIndex.value && dist < tolerance) {
//       selectedIndex.value = best;
//     }
//   }

//   double _getHeaderHeight() {
//     final ctx = headerKey.currentContext;
//     if (ctx == null) return 0;
//     final box = ctx.findRenderObject() as RenderBox?;
//     return (box?.attached ?? false) ? box!.size.height : 0;
//   }

//   void openViewer(CarGallerySectionsModel section, int initialIndex) {
//     // Get.toNamed(
//     //   AppRoutes.viewer,
//     //   arguments: {
//     //     'images': section.images,
//     //     'initialIndex': initialIndex,
//     //     'title': section.title,
//     //   },
//     //   preventDuplicates: false,
//     // );
//   }

//   @override
//   void onClose() {
//     scrollController.removeListener(_onScrollUpdateActiveChip);
//     scrollController.dispose();
//     super.onClose();
//   }
// }

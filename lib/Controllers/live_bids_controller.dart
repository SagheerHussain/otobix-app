import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/socket_events.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/helpers/Preferences_helper.dart';
import '../Network/api_service.dart';

class LiveBidsController extends GetxController {
  RxInt liveBidsCarsCount = 0.obs;
  List<CarsListModel> liveBidsCarsList = <CarsListModel>[];
  RxBool isLoading = false.obs;

  final RxSet<String> wishlistCarsIds = <String>{}.obs;

  @override
  void onInit() async {
    super.onInit();

    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

    // Fetch cars then wishlist, then apply hearts
    await fetchLiveBidsCarsList();
    await _fetchAndApplyWishlist(userId: userId);

    // Listen to realtime wishlist updates
    _listenWishlistRealtime();

    // Listen for patches
    _listenLiveBidsSectionRealtime();

    //Other listeners
    listenUpdatedBidAndChangeHighestBidLocally();
    // listenToAuctionWonEvent();
  }

  final RxList<CarsListModel> filteredLiveBidsCarsList = <CarsListModel>[].obs;

  // Live Bids Cars List
  Future<void> fetchLiveBidsCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus: AppConstants.auctionStatuses.live,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final currentTime = DateTime.now();

        // liveBidsCarsList = List<CarsListModel>.from(
        //   (data as List).map(
        //     (car) => CarsListModel.fromJson(data: car, id: car['id']),
        //   ),
        // );

        liveBidsCarsList =
            (data as List<dynamic>)
                .map<CarsListModel>(
                  (e) => CarsListModel.fromJson(
                    id: e['id'] as String,
                    data: Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList(); // ✅ growable

        // liveBidsCarsList = (data as List<dynamic>)
        //     .map<CarsListModel>(
        //       (e) => CarsListModel.fromJson(
        //         id: e['id'] as String,
        //         data: Map<String, dynamic>.from(e as Map),
        //       ),
        //     )
        //     .toList(growable: false);

        // Only keep cars with future auctionEndTime
        filteredLiveBidsCarsList.assignAll(
          liveBidsCarsList.where(
            (car) =>
                car.auctionEndTime != null &&
                car.auctionStatus == AppConstants.auctionStatuses.live &&
                car.auctionEndTime!.isAfter(currentTime),
          ),
        ); // ✅ stays growable
        // filteredLiveBidsCarsList.value = liveBidsCarsList
        //     .where((car) {
        //       return car.auctionEndTime != null &&
        //           car.auctionStatus == AppConstants.auctionStatuses.live &&
        //           car.auctionEndTime!.isAfter(currentTime);
        //     })
        //     .toList(growable: false);

        liveBidsCarsCount.value = filteredLiveBidsCarsList.length;

        // for (var car in liveBidsCarsList) {
        for (var car in filteredLiveBidsCarsList) {
          await startAuctionCountdown(car);
          debugPrint(car.toJson().toString());
        }
      } else {
        filteredLiveBidsCarsList.value = <CarsListModel>[];
        liveBidsCarsCount.value = 0;
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredLiveBidsCarsList.value = <CarsListModel>[];
      liveBidsCarsCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  // Listen and Update Bid locally
  void listenUpdatedBidAndChangeHighestBidLocally() {
    SocketService.instance.on(SocketEvents.bidUpdated, (data) {
      final String carId = data['carId'];
      final int highestBid = data['highestBid'];

      final index = filteredLiveBidsCarsList.indexWhere((c) => c.id == carId);
      if (index != -1) {
        filteredLiveBidsCarsList[index].highestBid.value =
            highestBid.toDouble(); // ✅ this is the real-time field
      }
      debugPrint('📢 Bid update received: $data');
    });
  }

  // Auction Timer
  Future<void> startAuctionCountdown(CarsListModel car) async {
    DateTime getAuctionEndTime() {
      // ✅ Prefer server's end time when present
      if (car.auctionEndTime != null) return car.auctionEndTime!.toLocal();
      final startTime = car.auctionStartTime!.toLocal() ?? DateTime.now();
      final duration = Duration(hours: car.auctionDuration);
      return startTime.add(duration);
    }

    car.auctionTimer?.cancel(); // cancel previous if any

    car.auctionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final endAt = getAuctionEndTime();
      final diff = endAt.difference(now);

      if (diff.isNegative) {
        // stop at zero instead of silently rolling another 12h
        car.remainingAuctionTime.value = '00h : 00m : 00s';
        car.auctionTimer?.cancel();
        return;
      }

      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
      car.remainingAuctionTime.value = '${hours}h : ${minutes}m : ${seconds}s';
    });
  }

  @override
  void onClose() {
    for (var car in filteredLiveBidsCarsList) {
      car.auctionTimer?.cancel();
    }
    super.onClose();
  }

  // Add Car To Wishlist
  Future<void> addCarToWishlist({required String carId}) async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    try {
      final url = AppUrls.addToWishlist;
      final response = await ApiService.post(
        endpoint: url,
        body: {'userId': userId, 'carId': carId},
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Car added to favourites',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to add car to favourites ${response.body}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to add car to favourites',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Failed to add car to favourites: $error');
    }
  }

  Future<void> _fetchAndApplyWishlist({required String userId}) async {
    try {
      final url = AppUrls.getUserWishlist(userId: userId);
      final response = await ApiService.get(endpoint: url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> ids = data['wishlist'] ?? [];

        wishlistCarsIds
          ..clear()
          ..addAll(ids.map((e) => '$e'));
      }
    } catch (e) {
      debugPrint('_fetchAndApplyWishlist error: $e');
    }
  }

  void _listenWishlistRealtime() {
    SocketService.instance.on(SocketEvents.wishlistUpdated, (data) {
      final String action = '${data['action']}';
      final String carId = '${data['carId']}';

      if (action == 'add') {
        wishlistCarsIds.add(carId);
      } else if (action == 'remove') {
        wishlistCarsIds.remove(carId);
      }
    });
  }

  /// Toggle (optimistic UI + rollback on error)
  Future<void> toggleFavorite(CarsListModel car) async {
    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
    final isFav = wishlistCarsIds.contains(car.id);

    // optimistic
    if (isFav) {
      wishlistCarsIds.remove(car.id);
    } else {
      wishlistCarsIds.add(car.id);
    }

    try {
      if (isFav) {
        final res = await ApiService.post(
          endpoint: AppUrls.removeFromWishlist,
          body: {'userId': userId, 'carId': car.id},
        );
        if (res.statusCode != 200) throw Exception(res.body);
        ToastWidget.show(
          context: Get.context!,
          title: 'Removed from wishlist',
          type: ToastType.error,
        );
      } else {
        final res = await ApiService.post(
          endpoint: AppUrls.addToWishlist,
          body: {'userId': userId, 'carId': car.id},
        );
        if (res.statusCode != 200) throw Exception(res.body);
        ToastWidget.show(
          context: Get.context!,
          title: 'Added to wishlist',
          type: ToastType.success,
        );
      }
      // Server will also emit wishlist:updated → sync other devices.
    } catch (e) {
      debugPrint('Failed to update wishlist: $e');
      // rollback
      if (isFav) {
        wishlistCarsIds.add(car.id);
      } else {
        wishlistCarsIds.remove(car.id);
      }
      ToastWidget.show(
        context: Get.context!,
        title: 'Failed to update wishlist',
        type: ToastType.error,
      );
    }
  }

  // Listen to live bids section realtime
  void _listenLiveBidsSectionRealtime() {
    SocketService.instance.joinRoom(SocketEvents.liveBidsSectionRoom);

    SocketService.instance.on(SocketEvents.liveBidsSectionUpdated, (
      data,
    ) async {
      final String action = '${data['action']}';

      if (action == 'removed') {
        final String id = '${data['id']}';
        // cancel its timer to avoid leaks
        final idx = filteredLiveBidsCarsList.indexWhere((c) => c.id == id);
        if (idx != -1) {
          filteredLiveBidsCarsList[idx].auctionTimer?.cancel();
        }
        // filteredLiveBidsCarsList.value =
        //     filteredLiveBidsCarsList.where((c) => c.id != id).toList();
        // liveBidsCarsCount.value = filteredLiveBidsCarsList.length;
        filteredLiveBidsCarsList.removeWhere(
          (c) => c.id == id,
        ); // simple & growable-safe
        liveBidsCarsCount.value = filteredLiveBidsCarsList.length;
        return;
      }

      if (action == 'added') {
        final String id = '${data['id']}';
        final Map<String, dynamic> carJson = Map<String, dynamic>.from(
          data['car'] ?? const {},
        );

        final incoming = CarsListModel.fromJson(id: id, data: carJson);
        debugPrint(incoming.toJson().toString());

        final idx = filteredLiveBidsCarsList.indexWhere((c) => c.id == id);

        if (idx == -1) {
          // brand-new → add, then start its timer
          filteredLiveBidsCarsList.add(incoming);
          await startAuctionCountdown(incoming);
        } else {
          // existing → cancel old timer, replace model, restart timer
          filteredLiveBidsCarsList[idx].auctionTimer?.cancel();
          filteredLiveBidsCarsList[idx] = incoming;
          await startAuctionCountdown(filteredLiveBidsCarsList[idx]);
        }
        // ✅ update count after mutation
        liveBidsCarsCount.value = filteredLiveBidsCarsList.length;
        return;
      }
    });
  }
}

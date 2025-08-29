import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Models/cars_list_model.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Network/socket_service.dart';
import 'package:otobix/Utils/app_constants.dart';
import 'package:otobix/Utils/app_urls.dart';
import 'package:otobix/Utils/socket_events.dart';

class AdminUpcomingCarsListController extends GetxController {
  RxInt upcomingCarsCount = 0.obs;
  List<CarsListModel> upcomingCarsList = [];
  RxBool isLoading = false.obs;

  // Countdown state
  final RxMap<String, String> remainingTimes = <String, String>{}.obs;
  final Map<String, Timer> _timers = {};

  final RxList<CarsListModel> filteredUpcomingCarsList = <CarsListModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchUpcomingCarsList();
    _listenUpcomingCarsSectionRealtime();
  }

  // Live Cars List
  Future<void> fetchUpcomingCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus: AppConstants.auctionStatuses.upcoming,
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        upcomingCarsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        upcomingCarsCount.value = upcomingCarsList.length;

        // filteredUpcomingCarsList.value = upcomingCarsList;
        // setupCountdowns(upcomingCarsList);

        filteredUpcomingCarsList.assignAll(upcomingCarsList);
        setupCountdowns(filteredUpcomingCarsList);
      } else {
        filteredUpcomingCarsList.clear();
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredUpcomingCarsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Single entry-point: wire countdowns to the given cars list.
  /// - Cancels timers for cars that disappeared
  /// - (Re)starts timers for provided cars
  /// - Formats "15h : 22m : 44s"
  void setupCountdowns(List<CarsListModel> cars) {
    // 1) Cancel timers that are no longer needed
    final newIds = cars.map((c) => c.id).toSet();
    final toRemove = _timers.keys.where((id) => !newIds.contains(id)).toList();
    for (final id in toRemove) {
      _timers[id]?.cancel();
      _timers.remove(id);
      remainingTimes.remove(id);
    }

    // Local helpers (kept inside this single function)
    String fmt(Duration d) {
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(d.inHours)}h : ${two(d.inMinutes % 60)}m : ${two(d.inSeconds % 60)}s';
    }

    void startFor(CarsListModel car) {
      // Cancel previous timer for this car (if any)
      _timers[car.id]?.cancel();

      final until = car.upcomingUntil;
      if (until == null) {
        remainingTimes[car.id] = 'N/A';
        return;
      }

      void tick() {
        final diff = until.difference(DateTime.now());
        if (diff.isNegative) {
          remainingTimes[car.id] = '00h : 00m : 00s';
          _timers[car.id]?.cancel();
          _timers.remove(car.id);
          return;
        }
        remainingTimes[car.id] = fmt(diff);
      }

      // Prime immediately, then every second
      tick();
      _timers[car.id] = Timer.periodic(
        const Duration(seconds: 1),
        (_) => tick(),
      );
    }

    // 2) Ensure every given car has an active timer
    for (final car in cars) {
      startFor(car);
    }
  }

  // Listen to upcoming cars section realtime
  void _listenUpcomingCarsSectionRealtime() {
    SocketService.instance.joinRoom(SocketEvents.upcomingBidsSectionRoom);

    SocketService.instance.on(SocketEvents.upcomingBidsSectionUpdated, (
      data,
    ) async {
      final String action = '${data['action']}';

      if (action == 'removed') {
        final String id = '${data['id']}';

        // cancel controller-owned timer & remove readable time
        _timers[id]?.cancel();
        _timers.remove(id);
        remainingTimes.remove(id);

        // remove from list
        filteredUpcomingCarsList.value =
            filteredUpcomingCarsList.where((c) => c.id != id).toList();

        // update count
        upcomingCarsCount.value = filteredUpcomingCarsList.length;
        return;
      }

      if (action == 'added') {
        final String id = '${data['id']}';
        final Map<String, dynamic> carJson = Map<String, dynamic>.from(
          data['car'] ?? const {},
        );
        final incoming = CarsListModel.fromJson(id: id, data: carJson);

        final idx = filteredUpcomingCarsList.indexWhere((c) => c.id == id);
        if (idx == -1) {
          filteredUpcomingCarsList.add(incoming);
        } else {
          // replace model (no model timers to cancel anymore)
          filteredUpcomingCarsList[idx] = incoming;
        }

        // refresh all timers via the single entry-point
        setupCountdowns(filteredUpcomingCarsList);

        // update count
        upcomingCarsCount.value = filteredUpcomingCarsList.length;
        return;
      }
    });
  }

  @override
  void onClose() {
    // stop all timers and clear remaining times via the same single function
    setupCountdowns(const []);

    // detach socket listener and leave room (avoid memory leaks / dup listeners)
    SocketService.instance.off(SocketEvents.upcomingBidsSectionUpdated);
    SocketService.instance.leaveRoom(SocketEvents.upcomingBidsSectionRoom);
    super.onClose();
  }
}

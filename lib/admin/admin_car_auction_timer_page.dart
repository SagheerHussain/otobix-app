import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix/Widgets/toast_widget.dart';
import 'package:otobix/admin/controller/admin_car_auction_timer_controller.dart';

class AdminCarAuctionTimerPage extends StatelessWidget {
  const AdminCarAuctionTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminCarAuctionTimerController());

    return Scaffold(
      appBar: AppBar(title: const Text('Auction Timers')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.cars.isEmpty) {
          return const Center(child: Text("No cars found."));
        }

        return ListView.builder(
          itemCount: controller.cars.length,
          itemBuilder: (context, index) {
            final car = controller.cars[index];

            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            car.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, _, __) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image),
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${car.make} ${car.model} ${car.variant}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Odometer: ${car.odometerReadingInKms} km'),
                              Text('Fuel: ${car.fuelType}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Auction Start Time: ${car.auctionStartTime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(car.auctionStartTime!.toLocal()) : 'Not set'}',
                    ),
                    Text(
                      'Auction End Time: ${car.auctionEndTime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(car.auctionEndTime!.toLocal()) : 'Not set'}',
                    ),
                    Text('Auction Duration: ${car.auctionDuration} hours'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final now = DateTime.now();
                              final initialAuctionDate =
                                  car.auctionStartTime != null &&
                                          !car.auctionStartTime!.isBefore(now)
                                      ? car.auctionStartTime!
                                      : now;

                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate:
                                    DateTime.now(), // only allow today or past dates
                              );

                              if (pickedDate != null) {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    DateTime.now(),
                                  ),
                                );

                                if (pickedTime != null) {
                                  final newStart = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );

                                  if (newStart.isAfter(DateTime.now())) {
                                    ToastWidget.show(
                                      context: Get.context!,
                                      title: 'Cannot select a future time',
                                      type: ToastType.error,
                                    );
                                    return;
                                  }

                                  await controller.updateAuctionTime(
                                    carId: car.id,
                                    newStartTime: newStart.toLocal(),
                                  );
                                }
                              }
                            },

                            icon: const Icon(Icons.access_time),
                            label: const Text(
                              'Change Start',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10),
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final durationController = TextEditingController(
                                text: car.auctionDuration.toString(),
                              );
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text(
                                        "Change Auction Duration",
                                      ),
                                      content: TextField(
                                        controller: durationController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: "Duration in hours",
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            final newDuration = int.tryParse(
                                              durationController.text.trim(),
                                            );
                                            if (newDuration != null) {
                                              await controller
                                                  .updateAuctionTime(
                                                    carId: car.id,
                                                    newDuration: newDuration,
                                                  );
                                            }
                                            Get.back();
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    ),
                              );
                            },

                            icon: const Icon(Icons.edit),
                            label: const Text(
                              'Change Duration',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

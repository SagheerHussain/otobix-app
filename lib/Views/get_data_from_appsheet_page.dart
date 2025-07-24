import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:otobix/Models/car_model2.dart';
import 'package:otobix/Network/api_service.dart';
import 'package:otobix/Utils/app_colors.dart';
import 'package:otobix/Utils/app_urls.dart';

class GetDataFromAppsheetPage extends StatefulWidget {
  const GetDataFromAppsheetPage({super.key});

  @override
  State<GetDataFromAppsheetPage> createState() =>
      _GetDataFromAppsheetPageState();
}

class _GetDataFromAppsheetPageState extends State<GetDataFromAppsheetPage> {
  CarModel2? carDetails;

  Future<void> fetchCarDetails() async {
    final carId = '68821747968635d593293346';
    try {
      final url = AppUrls.getCarDetails(carId);
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          carDetails = CarModel2.fromJson(data['carDetails']);
        });
        debugPrint('Car Details Fetched Successfully');
      } else {
        debugPrint('Failed to load data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to load data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCarDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        elevation: 10,
        backgroundColor: AppColors.green,
      ),
      body:
          carDetails == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _sectionTitle('Basic Information'),
                  _infoRow(
                    'Registration Number',
                    carDetails?.registrationNumber,
                  ),
                  _infoRow(
                    'Contact Number',
                    carDetails?.contactNumber.toString(),
                  ),
                  _infoRow('Make', carDetails?.make),
                  _infoRow('Model', carDetails?.model),
                  _infoRow('Fuel Type', carDetails?.fuelType),
                  _infoRow('City', carDetails?.city),
                  _infoRow('Variant', carDetails?.variant),

                  const SizedBox(height: 20),
                  _sectionTitle('RC & Documents'),
                  _infoRow(
                    'RC Book Availability',
                    carDetails?.rcBookAvailability,
                  ),
                  _infoRow('RC Condition', carDetails?.rcCondition),
                  _infoRow('Insurance', carDetails?.insurance),
                  _infoRow('RC Tax Token', carDetails?.rcTaxToken),

                  const SizedBox(height: 20),
                  _sectionTitle('Mechanical & Safety'),
                  _infoRow('Engine', carDetails?.engine),
                  _infoRow('Gear Shift', carDetails?.gearShift),
                  _infoRow('Clutch', carDetails?.clutch),
                  _infoRow('Suspension', carDetails?.suspension),
                  _infoRow('ABS', carDetails?.abs),
                  _infoRow('Airbags', carDetails?.noOfAirBags016?.toString()),

                  const SizedBox(height: 20),
                  _sectionTitle('Multimedia'),
                  _infoRow('Music System', carDetails?.musicSystem),
                  _infoRow('Stereo', carDetails?.stereo),
                  _infoRow('Speakers', carDetails?.inbuiltSpeaker),

                  const SizedBox(height: 20),
                  _sectionTitle('Images'),
                  _imageGrid([
                    carDetails?.frontMain,
                    carDetails?.rearMain,
                    carDetails?.engineBay,
                  ]),
                ],
              ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(child: Text(value ?? '-', textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _imageGrid(List<String?> images) {
    final filteredImages = images.whereType<String>().toList();
    if (filteredImages.isEmpty) {
      return const Text('No images available');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(filteredImages[index], fit: BoxFit.cover),
        );
      },
    );
  }
}

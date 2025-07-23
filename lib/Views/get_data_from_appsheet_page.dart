import 'dart:convert';
import 'package:flutter/material.dart';
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
  var sheetData = [];

  Future<void> fetchData() async {
    try {
      final url = AppUrls.approvedUsersList;
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        sheetData = decodedResponse['data'] ?? [];
        debugPrint('Sheet Data: ${sheetData.toString()}');
        setState(() {});
      } else {
        debugPrint('Failed to load data');
      }
    } catch (error) {
      debugPrint('Failed to load data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build method called');
    // fetchData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sheet Data', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        elevation: 10,
        backgroundColor: AppColors.green,
      ),
      body: Center(
        child: SingleChildScrollView(child: Text(sheetData.toString())),
      ),
      // body: ListView.builder(
      //   itemCount: sheetData.length,
      //   itemBuilder: (context, index) {
      //     final item = sheetData[index];
      //     return ListTile(
      //       leading: Image.network(item['image']),
      //       title: Text(item['title']),
      //       subtitle: Text(item['description']),
      //     );
      //   },
      // ),
    );
  }
}

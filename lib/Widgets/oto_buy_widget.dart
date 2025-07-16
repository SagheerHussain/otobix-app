import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix/Controllers/Home%20Tab/car_details_controller.dart';

void showMakeOfferSheet(BuildContext context) {
  final CarDetailsController bidController = Get.put(CarDetailsController());
  bidController.resetBidIncrement();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.45,
        initialChildSize: 0.45,
        builder: (_, controller) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TOP ROW — TITLE + TIMER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "One-click Buy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "23:47:56",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 20),

                  /// NEW: TOP ROW - PRICE BOX + BUY NOW BUTTON
                  Row(
                    children: [
                      /// PRICE BOX
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Rs. 7,77,000",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      /// BUY NOW BUTTON
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // implement your logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "BUY NOW",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  /// MID BOX — LIKE ORIGINAL DESIGN
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// LEFT - One-click Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "One-click Price",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Rs 7,77,000",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        /// Divider
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey[300],
                        ),

                        /// RIGHT - Your Offer
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Your Offer",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(() => Text(
                                  "Rs ${bidController.bidAmount.value}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  /// +/- CONTROLS
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// MINUS BUTTON
                        GestureDetector(
                          onTap: () {
                            bidController.decreaseBid();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.remove,
                                color: Colors.red, size: 20),
                          ),
                        ),
                        SizedBox(width: 30),

                        /// BID VALUE
                        Obx(() => Column(
                              children: [
                                Text(
                                  "Rs ${bidController.bidAmount.value}",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "*Bid increase by Rs ${bidController.isFirstClick ? 4000 : 1000}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            )),
                        SizedBox(width: 30),

                        /// PLUS BUTTON
                        GestureDetector(
                          onTap: () {
                            bidController.increaseBid();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add,
                                color: Colors.green, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  /// NEW: MAKE YOUR OFFER NOW BUTTON
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "MAKE YOUR OFFER NOW ${bidController.bidAmount.value}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

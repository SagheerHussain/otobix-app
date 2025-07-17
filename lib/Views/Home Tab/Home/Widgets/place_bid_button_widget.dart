import 'package:flutter/material.dart';
import 'package:otobix/Widgets/bid_dialogue.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Controllers/Home%20Tab/car_details_controller.dart';
import 'package:otobix/Widgets/oto_buy_widget.dart';
import 'package:otobix/Widgets/upcoming_bid.dart';

class PlaceBidButtonWidget extends StatelessWidget {
  const PlaceBidButtonWidget({
    super.key,
    required this.type,
    required this.getxController,
  });

  final String type;
  final CarDetailsController getxController;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text: 'Place Bid',
      onTap: () {
        if (type == 'upcoming') {
          upcomingBidSheet(context);
        } else if (type == 'live_bids') {
          showExactBidSheet(context);
        } else if (type == 'ocb_70') {
          showMakeOfferSheet(context);
        } else {
          showExactBidSheet(context);
        }
      },
      isLoading: getxController.isLoading,
      height: 30,
      fontSize: 10,
      elevation: 10,
    );
  }
}

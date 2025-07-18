import 'package:flutter/material.dart';
import 'package:otobix/Widgets/place_bid_button_for_live_bids_section.dart';
import 'package:otobix/Widgets/button_widget.dart';
import 'package:otobix/Controllers/car_details_controller.dart';
import 'package:otobix/Widgets/place_bid_button_for_ocb70_section.dart';
import 'package:otobix/Widgets/place_bid_button_for_upcoming_section.dart';

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
          placeBidButtonForUpcomingSection(context);
        } else if (type == 'live_bids') {
          placeBidButtonForLiveBidsSection(context);
        } else if (type == 'ocb_70') {
          placeBidButtonForOcb70Section(context);
        } else {
          placeBidButtonForLiveBidsSection(context);
        }
      },
      isLoading: getxController.isLoading,
      height: 30,
      fontSize: 10,
      elevation: 10,
    );
  }
}

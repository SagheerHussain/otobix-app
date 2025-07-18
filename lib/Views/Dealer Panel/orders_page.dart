import 'package:flutter/material.dart';
import 'package:otobix/Views/Dealer%20Panel/in_negotiation_page.dart';
import 'package:otobix/Views/Dealer%20Panel/procured_page.dart';
import 'package:otobix/Views/Dealer%20Panel/rc_transfer_page.dart';
import 'package:otobix/Widgets/tab_bar_widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),

            Expanded(
              child: TabBarWidget(
                titles: ['In Negotiation', 'Procured', 'RC Transfer'],
                counts: [3, 2, 5],
                screens: [
                  InNegotiationPage(),
                  ProcuredPage(),
                  RCTransferPage(),
                ],
                titleSize: 10,
                countSize: 8,
                spaceFromSides: 10,
                tabsHeight: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

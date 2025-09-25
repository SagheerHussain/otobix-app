class AppConstants {
  // Other constant classes
  static final Roles roles = Roles();
  static final AuctionStatuses auctionStatuses = AuctionStatuses();
  static final ImagesSectionIds imagesSectionIds = ImagesSectionIds();
  static final TabBarWidgetControllerTags tabBarWidgetControllerTags =
      TabBarWidgetControllerTags();

  static const List<String> indianStates = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Delhi",
    "Jammu and Kashmir",
    "Ladakh",
    "Lakshadweep",
    "Puducherry",
    "Patna",
    "Kolkata",
  ];
}

// User roles class
class Roles {
  // Fields
  final String dealer = 'Dealer';
  final String customer = 'Customer';
  final String salesManager = 'Sales Manager';
  final String admin = 'Admin';

  final String userStatusPending = 'Pending';
  final String userStatusApproved = 'Approved';
  final String userStatusRejected = 'Rejected';

  List<String> get all => [dealer, customer, salesManager, admin];
}

// Auction statuses class
class AuctionStatuses {
  final String all = 'all';
  final String upcoming = 'upcoming';
  final String live = 'live';
  final String otobuy = 'otobuy';
  final String marketplace = 'marketplace';
  final String liveAuctionEnded = 'liveAuctionEnded';
  final String sold = 'sold';
  final String otobuyEnded = 'otobuyEnded';
  final String removed = 'removed';

  // List<String> get all => [
  //   upcoming,
  //   live,
  //   otobuy,
  //   marketplace,
  //   liveAuctionEnded,
  //   otobuyEnded,
  // ];
}

// Images section ids
class ImagesSectionIds {
  final String exterior = 'exterior';
  final String interior = 'interior';
  final String engine = 'engine';
  final String suspension = 'suspension';
  final String ac = 'ac';
  final String tyres = 'tyres';
  final String damages = 'damages';

  List<String> get all => [exterior, interior, engine, suspension, ac];
}

//  TabBarWidgetController tags
class TabBarWidgetControllerTags {
  final String homeTabs = 'home_tabs';
  final String myCarsTabs = 'mycars_tabs';

  List<String> get all => [homeTabs, myCarsTabs];
}

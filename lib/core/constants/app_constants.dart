/// Central place for role strings, Firestore collection names, and
/// order status labels. Never hardcode these strings anywhere else.
class AppConstants {
  AppConstants._();

  // Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';
  static const String roleRider = 'rider';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String menuItemsCollection = 'menuItems';
  static const String categoriesCollection = 'categories';

  // Order status values — keep in sync with the state machine in the PRD.
  static const String statusPlaced = 'Order Placed';
  static const String statusAccepted = 'Accepted';
  static const String statusPreparing = 'Preparing';
  static const String statusPickedUp = 'Picked Up';
  static const String statusOnTheWay = 'On the Way';
  static const String statusDelivered = 'Delivered';
  static const String statusRejected = 'Rejected';
  static const String statusCancelled = 'Cancelled';

  static const List<String> orderStatusFlow = [
    statusPlaced,
    statusAccepted,
    statusPreparing,
    statusPickedUp,
    statusOnTheWay,
    statusDelivered,
  ];
}

import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_constants.dart';
import 'package:restaurant_app/features/menu/presentation/pages/menu_page.dart';
import 'package:restaurant_app/features/orders/presentation/pages/admin_dashboard_page.dart';
import 'package:restaurant_app/features/orders/presentation/pages/rider_dashboard_page.dart';

/// One place decides which home screen a role lands on. Nothing else in
/// the app should contain `if (role == 'admin')` routing logic.
class AppRouter {
  AppRouter._();

  static void goToRoleHome(BuildContext context, String role) {
    final Widget home = switch (role) {
      AppConstants.roleAdmin => const AdminDashboardPage(),
      AppConstants.roleRider => const RiderDashboardPage(),
      _ => const MenuPage(),
    };
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => home),
      (route) => false,
    );
  }
}

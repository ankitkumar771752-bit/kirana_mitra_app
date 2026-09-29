import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_routes.dart';

import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/customer/home/customer_home_screen.dart';
import 'views/customer/search/customer_search_screen.dart';
import 'views/customer/cart/customer_cart_screen.dart';
import 'views/customer/checkout/customer_checkout_screen.dart';
import 'views/customer/orders/customer_orders_screen.dart';
import 'views/customer/profile/customer_profile_screen.dart';

import 'views/delivery/home/delivery_home_screen.dart';
import 'views/delivery/requests/delivery_requests_screen.dart';
import 'views/delivery/tracking/delivery_tracking_screen.dart';
import 'views/delivery/history/delivery_history_screen.dart';
import 'views/delivery/earnings/delivery_earnings_screen.dart';

import 'views/store/dashboard/store_dashboard_screen.dart';
import 'views/store/products/store_products_screen.dart';
import 'views/store/inventory/store_inventory_screen.dart';
import 'views/store/orders/store_orders_screen.dart';
import 'views/store/sales/store_sales_screen.dart';
import 'views/store/profile/store_profile_screen.dart';

import 'views/admin/dashboard/admin_dashboard_screen.dart';
import 'views/admin/customers/admin_customers_screen.dart';
import 'views/admin/stores/admin_stores_screen.dart';
import 'views/admin/delivery/admin_delivery_screen.dart';
import 'views/admin/orders/admin_orders_screen.dart';
import 'views/admin/payments/admin_payments_screen.dart';
import 'views/admin/reports/admin_reports_screen.dart';

void main() {
  runApp(const KiranaMitraApp());
}

class KiranaMitraApp extends StatelessWidget {
  const KiranaMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KiranaMitra MVC',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.splash: (context) => const SignupScreen(),

        // Customer Routes
        AppRoutes.customerHome: (context) => const CustomerHomeScreen(),
        AppRoutes.customerSearch: (context) => const CustomerSearchScreen(),
        AppRoutes.customerCart: (context) => const CustomerCartScreen(),
        AppRoutes.customerCheckout: (context) => const CustomerCheckoutScreen(),
        AppRoutes.customerOrders: (context) => const CustomerOrdersScreen(),
        AppRoutes.customerProfile: (context) => const CustomerProfileScreen(),

        // Delivery Routes
        AppRoutes.deliveryHome: (context) => const DeliveryHomeScreen(),
        AppRoutes.deliveryRequests: (context) => const DeliveryRequestsScreen(),
        AppRoutes.deliveryTracking: (context) => const DeliveryTrackingScreen(),
        AppRoutes.deliveryHistory: (context) => const DeliveryHistoryScreen(),
        AppRoutes.deliveryEarnings: (context) => const DeliveryEarningsScreen(),

        // Store Routes
        AppRoutes.storeDashboard: (context) => const StoreDashboardScreen(),
        AppRoutes.storeProducts: (context) => const StoreProductsScreen(),
        AppRoutes.storeInventory: (context) => const StoreInventoryScreen(),
        AppRoutes.storeOrders: (context) => const StoreOrdersScreen(),
        AppRoutes.storeSales: (context) => const StoreSalesScreen(),
        AppRoutes.storeProfile: (context) => const StoreProfileScreen(),

        // Admin Routes
        AppRoutes.adminDashboard: (context) => const AdminDashboardScreen(),
        AppRoutes.adminCustomers: (context) => const AdminCustomersScreen(),
        AppRoutes.adminStores: (context) => const AdminStoresScreen(),
        AppRoutes.adminDelivery: (context) => const AdminDeliveryScreen(),
        AppRoutes.adminOrders: (context) => const AdminOrdersScreen(),
        AppRoutes.adminPayments: (context) => const AdminPaymentsScreen(),
        AppRoutes.adminReports: (context) => const AdminReportsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

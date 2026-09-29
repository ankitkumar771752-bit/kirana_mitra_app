import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KiranaMitra - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Welcome to KiranaMitra',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email / Phone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.customerHome);
              },
              child: const Text('Login as Customer', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Quick Role Testing Dashboards:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.delivery_dining, color: Colors.blue),
              label: const Text('Open Delivery Partner Module'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.deliveryHome);
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.store, color: Colors.green),
              label: const Text('Open Store Owner Module'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.storeDashboard);
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.purple),
              label: const Text('Open Admin Panel Module'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.adminDashboard);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.splash);
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

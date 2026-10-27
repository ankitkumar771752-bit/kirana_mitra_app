import 'package:flutter/material.dart';
import '../../../app/routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';
import 'store_edit_profile_screen.dart';
import 'store_information_screen.dart';

class StoreProfileScreen extends StatelessWidget {
  const StoreProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthController.instance,
      builder: (context, child) {
        final user = AuthController.instance.currentUser;
        final storeName = user?.name.isNotEmpty == true ? user!.name : 'Kirana Mitra Store';

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Profile Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade100, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.15), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.store, size: 40, color: Colors.green.shade800),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(storeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 2),
                              const Text('Store Owner', style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    child: Text('ID: ${user?.id ?? 'KM1234'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('● Online', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Menu Items Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 2)],
                    ),
                    child: Column(
                      children: [
                        _ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update store owner details',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreEditProfileScreen()));
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.storefront_outlined,
                          title: 'Store Information',
                          subtitle: 'GST, License & Address',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreInformationScreen()));
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.access_time_outlined,
                          title: 'Business Hours',
                          subtitle: 'Set opening and closing timings',
                          color: Colors.orange,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.payment_outlined,
                          title: 'Payment Methods',
                          subtitle: 'Bank account & UPI setup',
                          color: Colors.purple,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications Settings',
                          subtitle: 'Order alerts & offers',
                          color: Colors.teal,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Contact partner support',
                          color: Colors.indigo,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          subtitle: 'Sign out from store account',
                          color: Colors.red,
                          onTap: () {
                            AuthController.instance.logout();
                            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ProfileMenuItem({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
    );
  }
}

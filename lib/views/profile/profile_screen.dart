import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    OrderController.instance.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([AuthController.instance, OrderController.instance]),
      builder: (context, child) {
        final user = AuthController.instance.currentUser;
        final userName = user?.name.isNotEmpty == true ? user!.name : 'Guest User';
        final userPhone = user?.phone ?? '';
        final userRole = user?.role.isNotEmpty == true ? user!.role : 'Customer';
        final userEmail = user?.email ?? '';
        final totalOrdersCount = OrderController.instance.orders.length.toString();

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Top App Bar row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                final role = (AuthController.instance.currentUser?.role ?? '').toLowerCase();
                                if (role.contains('store')) {
                                  Navigator.pushReplacementNamed(context, AppRoutes.storeDashboard);
                                } else if (role.contains('admin')) {
                                  Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
                                } else if (role.contains('delivery')) {
                                  Navigator.pushReplacementNamed(context, AppRoutes.deliveryHome);
                                } else {
                                  Navigator.pushReplacementNamed(context, AppRoutes.customerHome);
                                }
                              }
                            },
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.shopping_cart_rounded, color: Colors.green, size: 26),
                          const SizedBox(width: 6),
                          const Text('KiranaMitra', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 22)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.black87),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Profile Header Card with Gradient (Showing strictly logged-in user data)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade100, Colors.green.shade400, Colors.teal.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 38,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userPhone,
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.verified_user, size: 14, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(
                                        userRole.toUpperCase(),
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Shopping made easy 🌱',
                                    style: TextStyle(fontSize: 11, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.edit, size: 16, color: Colors.green),
                            label: const Text('Edit Profile', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              _showEditProfileModal(context, userName, userPhone, userEmail, userRole);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row Card (Wallet, Coupons, Avg Rating, Total Orders)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, spreadRadius: 2)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const _StatItem(icon: Icons.account_balance_wallet, value: '₹0', label: 'Wallet Balance', color: Colors.green),
                        const _StatItem(icon: Icons.local_offer, value: '3', label: 'Coupons', color: Colors.orange),
                        const _StatItem(icon: Icons.star, value: '4.8', label: 'Avg. Rating', color: Colors.amber),
                        _StatItem(icon: Icons.inventory_2, value: totalOrdersCount, label: 'Total Orders', color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          subtitle: 'View your order history',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.customerOrders);
                          },
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Delivery Addresses',
                          subtitle: 'Manage your saved addresses',
                          color: Colors.purple,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.favorite_border,
                          title: 'Wishlist',
                          subtitle: 'Your saved products',
                          color: Colors.pink,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.payment_outlined,
                          title: 'Payment Methods',
                          subtitle: 'UPI / Cards / Wallet',
                          color: Colors.blue,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.local_offer_outlined,
                          title: 'My Coupons',
                          subtitle: 'View available offers',
                          color: Colors.orange,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help when you need it',
                          color: Colors.teal,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: 'About KiranaMitra',
                          subtitle: 'Version 1.0.0',
                          color: Colors.grey,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _ProfileMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          subtitle: 'Sign out from your account',
                          color: Colors.red,
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileModal(BuildContext context, String currentName, String currentPhone, String currentEmail, String currentRole) {
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);
    final emailController = TextEditingController(text: currentEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(radius: 40, backgroundColor: Colors.green, child: Icon(Icons.person, size: 50, color: Colors.white)),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(controller: nameController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 14),
              const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 14),
              const Text('Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final user = AuthController.instance.currentUser ?? UserModel(
                      id: 'usr_default',
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      role: currentRole,
                    );

                    AuthController.instance.login(
                      user.copyWith(
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        email: emailController.text.trim(),
                      ),
                    );

                    Navigator.pop(context);
                    _showSuccessDialog(context);
                  },
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 50, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text('Profile Updated Successfully', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Your profile details have been updated successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out of KiranaMitra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              AuthController.instance.logout();
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
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

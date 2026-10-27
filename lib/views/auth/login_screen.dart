import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

/// Allows either a phone number or an email in the same field.
/// - If the text is digits only, it can't exceed 10 digits.
/// - Spaces are not allowed.
class _PhoneOrEmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.contains(' ')) return oldValue;
    final onlyDigits = RegExp(r'^\d+$').hasMatch(text);
    if (onlyDigits && text.length > 10) return oldValue;
    return newValue;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: Stack(
        children: [
          // Back button to Role Selection
          Positioned(
            top: 40,
            left: 16,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Background Branding / Illustration Area
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.shopping_bag_rounded, size: 45, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'KiranaMitra',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Har Ghar Ki Zarurat Ab Mobile Par',
                  style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Modal Bottom Sheet Style Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Modal Handle Bar
                    Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Selected Role Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Text(
                          'Logging in as: ${AuthController.instance.selectedRegistrationRole}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Please login with your registered account',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Text('Mobile Number / Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      inputFormatters: [_PhoneOrEmailInputFormatter()],
                      decoration: InputDecoration(
                        hintText: 'Enter 10-digit mobile or email',
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.green),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                setState(() {
                                  rememberMe = val ?? false;
                                });
                              },
                            ),
                            const Text('Remember me', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);

                          final identifier = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (identifier.isEmpty || password.isEmpty) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text('Please enter mobile/email and password'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final error = AuthController.validateIdentifier(identifier);
                          if (error != null) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(error), backgroundColor: Colors.red),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          final errorMsg = await AuthController.instance.loginUser(
                            emailOrPhone: identifier,
                            password: password,
                            expectedRole: AuthController.instance.selectedRegistrationRole,
                          );

                          if (!mounted) return;
                          setState(() {
                            isLoading = false;
                          });

                          if (errorMsg == null) {
                            final user = AuthController.instance.currentUser;
                            final role = (user?.role ?? '').toLowerCase();
                            if (role.contains('store')) {
                              navigator.pushReplacementNamed(AppRoutes.storeDashboard);
                            } else if (role.contains('admin')) {
                              navigator.pushReplacementNamed(AppRoutes.adminDashboard);
                            } else if (role.contains('delivery')) {
                              navigator.pushReplacementNamed(AppRoutes.deliveryHome);
                            } else {
                              navigator.pushReplacementNamed(AppRoutes.customerHome);
                            }
                          } else {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(errorMsg),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: const Text('Register Here', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


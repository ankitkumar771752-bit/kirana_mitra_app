import 'package:flutter/material.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignedRole = AuthController.instance.selectedRegistrationRole;

    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: Stack(
        children: [
          // Background Branding
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
                    child: Icon(Icons.person_add_rounded, size: 45, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Join KiranaMitra',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Create your account to get started',
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
                    const SizedBox(height: 16),
                    // Assigned Role Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_user, size: 14, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              'Registering as: $assignedRole',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Mobile Number (10 Digits) / Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneOrEmailController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'Enter 10-digit mobile or email',
                        prefixIcon: const Icon(Icons.contact_mail_outlined, color: Colors.green),
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
                        hintText: 'Enter password (min 6 characters)',
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
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
                    const SizedBox(height: 24),
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
                                final name = _nameController.text.trim();
                                final emailOrPhone = _phoneOrEmailController.text.trim();
                                final password = _passwordController.text.trim();
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);

                                if (name.isEmpty || emailOrPhone.isEmpty || password.isEmpty) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(content: Text('Please fill all required fields'), backgroundColor: Colors.red),
                                  );
                                  return;
                                }

                                // 1. Strict Email & Mobile Validation
                                final identifierError = AuthController.validateIdentifier(emailOrPhone);
                                if (identifierError != null) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(identifierError),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // 2. Check password length
                                if (password.length < 6) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Password must be at least 6 characters long'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                final success = await AuthController.instance.registerUser(
                                  name: name,
                                  emailOrPhone: emailOrPhone,
                                  password: password,
                                  role: assignedRole,
                                );

                                if (!mounted) return;
                                setState(() {
                                  isLoading = false;
                                });

                                if (success) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Registration successful! Please login.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                                } else {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Registration failed. Mobile/Email already registered.'),
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
                                'Register',
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?', style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Login here', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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

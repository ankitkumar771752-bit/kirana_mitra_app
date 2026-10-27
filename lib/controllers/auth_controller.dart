import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthController extends ChangeNotifier {
  static final AuthController instance = AuthController._internal();
  AuthController._internal();
  factory AuthController() => instance;

  String selectedRegistrationRole = 'Customer';

  // In-memory registered users database
  final List<Map<String, dynamic>> _registeredUsers = [];

  UserModel? _currentUser;
  bool _isInitialized = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  static const String _keySession = 'active_user_session';
  static const String _keyRegisteredUsers = 'registered_users';

  static final RegExp _basicEmailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static const Set<String> _validTlds = {
    'com', 'in', 'org', 'net', 'edu', 'gov', 'co.in', 'io', 'ai', 'info',
    'biz', 'me', 'app', 'dev', 'store', 'site', 'tech', 'online', 'us', 'uk', 'ca', 'au'
  };

  /// Strictly validates email addresses, catching domain typos like gmai, gmail.co, gmail.con, gmail.c, etc.
  static String? validateEmail(String email) {
    final clean = email.trim().toLowerCase();

    if (clean.isEmpty) {
      return 'Please enter a valid email address';
    }

    final parts = clean.split('@');
    if (parts.length != 2) {
      return 'Email must contain exactly one "@" symbol';
    }

    final localPart = parts[0];
    final fullDomain = parts[1];

    if (localPart.isEmpty || localPart.startsWith('.') || localPart.endsWith('.') || localPart.contains('..')) {
      return 'Invalid email username format';
    }

    if (fullDomain.isEmpty || fullDomain.startsWith('.') || fullDomain.endsWith('.') || fullDomain.contains('..')) {
      return 'Invalid email domain format';
    }

    final domainParts = fullDomain.split('.');
    if (domainParts.length < 2) {
      return 'Email must include a valid domain extension (e.g. @gmail.com)';
    }

    final domainName = domainParts[0];
    final tld = domainParts.sublist(1).join('.');

    // Check popular email provider typos (gmail, yahoo, hotmail, outlook)
    if (domainName == 'gmai' || domainName == 'gmal' || domainName == 'gmial' || domainName == 'gamil' || domainName == 'gmail') {
      if (domainName != 'gmail') {
        return 'Invalid domain "$domainName". Did you mean "@gmail.com"?';
      }
      if (tld == 'co') {
        return 'Did you mean "@gmail.com" or "@gmail.co.in"? ("gmail.co" is invalid)';
      }
      if (tld == 'c' || tld == 'con' || tld == 'cm' || tld == 'comm' || tld == 'om') {
        return 'Invalid domain extension ".$tld". Did you mean "@gmail.com"?';
      }
      if (tld != 'com' && tld != 'co.in' && tld != 'in' && tld != 'org') {
        return 'Invalid Gmail extension ".$tld". Use "@gmail.com" or "@gmail.co.in"';
      }
    }

    if (domainName == 'yaho' || domainName == 'yahooo' || domainName == 'yahoo') {
      if (domainName != 'yahoo') {
        return 'Invalid domain "$domainName". Did you mean "@yahoo.com"?';
      }
      if (tld == 'co' || tld == 'c' || tld == 'con' || tld == 'cm') {
        return 'Invalid extension ".$tld". Did you mean "@yahoo.com"?';
      }
      if (tld != 'com' && tld != 'co.in' && tld != 'in' && tld != 'org') {
        return 'Invalid Yahoo extension ".$tld". Use "@yahoo.com" or "@yahoo.co.in"';
      }
    }

    if (domainName == 'hotm' || domainName == 'hotmai' || domainName == 'hotmail') {
      if (domainName != 'hotmail') {
        return 'Invalid domain "$domainName". Did you mean "@hotmail.com"?';
      }
      if (tld == 'co' || tld == 'c' || tld == 'con' || tld == 'cm') {
        return 'Invalid extension ".$tld". Did you mean "@hotmail.com"?';
      }
      if (tld != 'com' && tld != 'co.in' && tld != 'in') {
        return 'Invalid Hotmail extension. Use "@hotmail.com"';
      }
    }

    if (domainName == 'outloo' || domainName == 'outlok' || domainName == 'outlook') {
      if (domainName != 'outlook') {
        return 'Invalid domain "$domainName". Did you mean "@outlook.com"?';
      }
      if (tld == 'co' || tld == 'c' || tld == 'con' || tld == 'cm') {
        return 'Invalid extension ".$tld". Did you mean "@outlook.com"?';
      }
      if (tld != 'com' && tld != 'co.in' && tld != 'in') {
        return 'Invalid Outlook extension. Use "@outlook.com"';
      }
    }

    final lastTld = domainParts.last;
    if (lastTld.length < 2) {
      return 'Invalid domain extension ".$lastTld". Extension must be at least 2 characters';
    }

    if (lastTld == 'con' || lastTld == 'comm' || lastTld == 'cm' || lastTld == 'om') {
      return 'Invalid domain extension ".$lastTld". Did you mean ".com"?';
    }

    if (!_validTlds.contains(tld) && !_validTlds.contains(lastTld)) {
      return 'Invalid domain extension ".$tld". Use a valid domain like .com or .in';
    }

    if (!_basicEmailRegex.hasMatch(clean)) {
      return 'Invalid email address format! Example: user@gmail.com';
    }

    return null;
  }

  /// Validates input as either a valid 10-digit mobile number OR a strictly valid email.
  static String? validateIdentifier(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Please enter 10-digit mobile or email address';
    }

    bool isEmail = trimmed.contains('@') || RegExp(r'[a-zA-Z]').hasMatch(trimmed);

    if (isEmail) {
      return validateEmail(trimmed);
    }

    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      if (trimmed.length != 10) {
        return 'Mobile number must be exactly 10 digits!';
      }
      return null;
    }

    return 'Please enter a valid 10-digit mobile or email address';
  }

  // Initialize and restore saved session + registered users
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load registered users from local storage
      final String? usersJson = prefs.getString(_keyRegisteredUsers);
      if (usersJson != null && usersJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(usersJson);
        _registeredUsers.clear();
        for (var u in decoded) {
          if (u is Map<String, dynamic>) {
            _registeredUsers.add(Map<String, dynamic>.from(u));
          }
        }
      }

      // Load saved user session
      final String? sessionJson = prefs.getString(_keySession);
      if (sessionJson != null && sessionJson.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(sessionJson);
        _currentUser = UserModel.fromJson(userMap);
      }
    } catch (e) {
      debugPrint('Error initializing AuthController session: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Save session to SharedPreferences
  Future<void> _saveSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySession, jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Error saving user session: $e');
    }
  }

  // Save registered users list to SharedPreferences
  Future<void> _persistRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyRegisteredUsers, jsonEncode(_registeredUsers));
    } catch (e) {
      debugPrint('Error persisting registered users: $e');
    }
  }

  // Validate 10-digit phone number
  static bool isValidPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10;
  }

  // Register User with strict validation and persistence
  Future<bool> registerUser({
    required String name,
    required String emailOrPhone,
    required String password,
    required String role,
  }) async {
    await init();

    // Strict validation check
    final validationError = validateIdentifier(emailOrPhone);
    if (validationError != null) {
      return false; // Strict validation failed!
    }

    final String email = emailOrPhone.contains('@') ? emailOrPhone.trim().toLowerCase() : '';
    final String phone = !emailOrPhone.contains('@') ? emailOrPhone.trim() : '';

    // Check if user already exists locally
    final existing = _registeredUsers.any(
      (u) => (email.isNotEmpty && u['email'] == email) || (phone.isNotEmpty && u['phone'] == phone),
    );
    if (existing) return false;

    try {
      await ApiService.post('/api/auth/register', {
        'name': name,
        'email': email,
        'phone': phone,
        'emailOrPhone': emailOrPhone,
        'password': password,
        'role': role,
      });
    } catch (e) {
      debugPrint('Live Register API Error (proceeding with local registration): $e');
    }

    _registeredUsers.add({
      'email': email,
      'phone': phone,
      'password': password,
      'name': name,
      'role': role,
    });

    await _persistRegisteredUsers();
    return true;
  }

  // Login User checking backend API or prior registration with role enforcement
  Future<String?> loginUser({required String emailOrPhone, required String password, String? expectedRole}) async {
    await init();

    final cleanInput = emailOrPhone.trim().toLowerCase();
    final roleToCheck = expectedRole ?? selectedRegistrationRole;

    // 1. Try Backend API Login first
    try {
      final response = await ApiService.post('/api/auth/login', {
        'emailOrPhone': emailOrPhone,
        'email': emailOrPhone.contains('@') ? emailOrPhone : '',
        'phone': !emailOrPhone.contains('@') ? emailOrPhone : '',
        'identifier': emailOrPhone,
        'password': password,
        'role': roleToCheck,
      });

      if (response != null) {
        Map<String, dynamic>? userData;
        if (response is Map<String, dynamic>) {
          if (response['user'] is Map<String, dynamic>) {
            userData = response['user'];
          } else if (response['data'] is Map<String, dynamic>) {
            userData = response['data'];
          } else if (response.containsKey('id') || response.containsKey('_id') || response.containsKey('name')) {
            userData = response;
          }
        }

        if (userData != null) {
          String? token;
          if (response is Map<String, dynamic>) {
            token = response['token']?.toString() ??
                response['accessToken']?.toString() ??
                response['access_token']?.toString() ??
                response['jwt']?.toString() ??
                response['authToken']?.toString() ??
                response['auth_token']?.toString();

            if (token == null && response['data'] is Map) {
              final d = response['data'] as Map;
              token = d['token']?.toString() ??
                  d['accessToken']?.toString() ??
                  d['access_token']?.toString() ??
                  d['jwt']?.toString() ??
                  d['authToken']?.toString() ??
                  d['auth_token']?.toString();
            }

            if (token == null && response['user'] is Map) {
              final u = response['user'] as Map;
              token = u['token']?.toString() ??
                  u['accessToken']?.toString() ??
                  u['access_token']?.toString() ??
                  u['jwt']?.toString() ??
                  u['authToken']?.toString() ??
                  u['auth_token']?.toString();
            }
          }

          if (token != null && token.isNotEmpty) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            debugPrint('Valid JWT Auth token captured and saved: $token');
          } else {
            debugPrint('Warning: Login response did not contain a token. Response: $response');
          }

          final fetchedRole = userData['role']?.toString() ?? 'Customer';
          if (roleToCheck.isNotEmpty && !_rolesMatch(fetchedRole, roleToCheck)) {
            return 'This account is registered as "$fetchedRole", not as "$roleToCheck". Please select the correct role.';
          }

          _currentUser = UserModel(
            id: userData['id']?.toString() ?? userData['_id']?.toString() ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
            name: userData['name']?.toString() ?? 'User',
            email: userData['email']?.toString() ?? (emailOrPhone.contains('@') ? emailOrPhone : ''),
            phone: userData['phone']?.toString() ?? (!emailOrPhone.contains('@') ? emailOrPhone : ''),
            role: fetchedRole,
          );

          // Update local registered user database
          final String email = _currentUser!.email;
          final String phone = _currentUser!.phone;
          final existingIndex = _registeredUsers.indexWhere(
            (u) => (email.isNotEmpty && u['email'] == email) || (phone.isNotEmpty && u['phone'] == phone),
          );
          if (existingIndex >= 0) {
            _registeredUsers[existingIndex] = {
              'email': email,
              'phone': phone,
              'password': password,
              'name': _currentUser!.name,
              'role': fetchedRole,
            };
          } else {
            _registeredUsers.add({
              'email': email,
              'phone': phone,
              'password': password,
              'name': _currentUser!.name,
              'role': fetchedRole,
            });
          }
          await _persistRegisteredUsers();
          await _saveSession(_currentUser!);
          notifyListeners();
          return null;
        }
      }
    } catch (e) {
      debugPrint('Live Login API Error (checking local database): $e');
    }

    // 2. Fallback to local saved registered users database
    Map<String, dynamic>? userMap;
    try {
      userMap = _registeredUsers.firstWhere(
        (u) => (u['email'].toString().toLowerCase() == cleanInput || u['phone'].toString().trim() == cleanInput),
      );
    } catch (_) {
      userMap = null;
    }

    if (userMap == null) {
      return 'User not found. Please register first.';
    }

    if (userMap['password'] != password) {
      return 'Incorrect password.';
    }

    final registeredRole = userMap['role'] ?? 'Customer';
    if (roleToCheck.isNotEmpty && !_rolesMatch(registeredRole, roleToCheck)) {
      return 'This account is registered as "$registeredRole", not as "$roleToCheck". Please select the correct role.';
    }

    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: userMap['name'] ?? 'User',
      email: userMap['email'].isNotEmpty ? userMap['email'] : emailOrPhone,
      phone: userMap['phone'].isNotEmpty ? userMap['phone'] : emailOrPhone,
      role: registeredRole,
    );
    await _saveSession(_currentUser!);
    notifyListeners();
    return null;
  }

  bool _rolesMatch(String userRole, String expectedRole) {
    final r1 = userRole.toLowerCase();
    final r2 = expectedRole.toLowerCase();
    if (r1 == r2) return true;
    if (r1.contains('store') && r2.contains('store')) return true;
    if (r1.contains('delivery') && r2.contains('delivery')) return true;
    if (r1.contains('admin') && r2.contains('admin')) return true;
    if (r1.contains('customer') && r2.contains('customer')) return true;
    return false;
  }

  Future<void> login(UserModel user) async {
    _currentUser = user;
    await _saveSession(user);
    notifyListeners();
  }

  static Future<bool> refreshBackendToken() async {
    try {
      final user = instance.currentUser;
      if (user == null) return false;

      final response = await ApiService.post('/api/auth/login', {
        'emailOrPhone': user.email.isNotEmpty ? user.email : user.phone,
        'email': user.email,
        'phone': user.phone,
        'password': 'password123',
        'role': user.role,
      });

      if (response != null && response is Map<String, dynamic>) {
        String? token = response['token']?.toString() ??
            response['accessToken']?.toString() ??
            response['access_token']?.toString() ??
            response['jwt']?.toString() ??
            response['authToken']?.toString() ??
            response['auth_token']?.toString();

        if (token == null && response['data'] is Map) {
          final d = response['data'] as Map;
          token = d['token']?.toString() ??
              d['accessToken']?.toString() ??
              d['access_token']?.toString() ??
              d['jwt']?.toString() ??
              d['authToken']?.toString() ??
              d['auth_token']?.toString();
        }

        if (token == null && response['user'] is Map) {
          final u = response['user'] as Map;
          token = u['token']?.toString() ??
              u['accessToken']?.toString() ??
              u['access_token']?.toString() ??
              u['jwt']?.toString() ??
              u['authToken']?.toString() ??
              u['auth_token']?.toString();
        }

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          debugPrint('Refreshed valid JWT backend token successfully: $token');
          return true;
        }
      }
    } catch (e) {
      debugPrint('Failed to refresh backend token: $e');
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keySession);
    } catch (e) {
      debugPrint('Error clearing user session: $e');
    }
    notifyListeners();
  }
}

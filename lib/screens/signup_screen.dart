import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../controllers/user_data_controller.dart';
import 'login_screen.dart';
import 'verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = Get.put(AuthService());
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailValid = false;


  @override
  void initState() {
    super.initState();
    // Listen to email changes for validation
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _isEmailValid = email.contains('@') && email.contains('.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carrot Logo
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Image.asset(
                    'assets/images/vector.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Title
              const Text(
                'Kaydol',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Devam etmek için bilgilerinizi girin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // First Name Field
              TextField(
                controller: _firstNameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Ad',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF53B175)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),

              const SizedBox(height: 20),

              // Last Name Field
              TextField(
                controller: _lastNameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Soyad',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF53B175)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),

              const SizedBox(height: 20),

              // Username Field
              TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF53B175)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),

              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF53B175)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  suffixIcon: _isEmailValid
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF53B175),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF53B175)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Terms and Conditions
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Devam ederek '),
                    TextSpan(
                      text: 'Hizmet Şartları',
                      style: const TextStyle(
                        color: Color(0xFF53B175),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Show terms of service
                          Get.snackbar(
                            'Hizmet Şartları',
                            'Hizmet şartları yakında eklenecek',
                            backgroundColor: const Color(0xFF53B175),
                            colorText: Colors.white,
                          );
                        },
                    ),
                    const TextSpan(text: ' ve '),
                    TextSpan(
                      text: 'Gizlilik Politikası',
                      style: const TextStyle(
                        color: Color(0xFF53B175),
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Show privacy policy
                          Get.snackbar(
                            'Gizlilik Politikası',
                            'Gizlilik politikası yakında eklenecek',
                            backgroundColor: const Color(0xFF53B175),
                            colorText: Colors.white,
                          );
                        },
                    ),
                    const TextSpan(text: 'nı kabul etmiş olursunuz.'),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(() => ElevatedButton(
                  onPressed: _authService.isLoading
                      ? null
                      : () async {
                          // Form validasyonu
                          if (_firstNameController.text.isEmpty ||
                              _lastNameController.text.isEmpty ||
                              _usernameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            Get.snackbar(
                              'Hata',
                              'Lütfen tüm alanları doldurun',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (!_isEmailValid) {
                            Get.snackbar(
                              'Hata',
                              'Geçerli bir e-posta adresi girin',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          // Kullanıcı bilgilerini sakla (verification_screen.dart'ta kullanılacak)
                          Get.put(UserDataController()).updateUserData(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          // Telefon doğrulama kodunu gönder
                          final phoneNumber = Get.find<PhoneInputController>().phoneNumber;
                          if (phoneNumber.isNotEmpty) {
                            await _authService.sendPhoneVerificationCode(phoneNumber);
                            Get.to(() => const VerificationScreen());
                          } else {
                            Get.snackbar(
                              'Hata',
                              'Telefon numarası bulunamadı',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53B175),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _authService.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Kaydol',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
              ),

              const SizedBox(height: 24),

              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Zaten hesabım var, ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: const Text(
                        'giriş yap',
                        style: TextStyle(
                          color: Color(0xFF53B175),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

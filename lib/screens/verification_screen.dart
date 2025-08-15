import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../controllers/user_data_controller.dart';
import 'location_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthService _authService = Get.find<AuthService>();
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  String _code = '';
  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() => _onCodeChanged());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 4; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _onCodeChanged() {
    setState(() {
      _code = _controllers.map((controller) => controller.text).join();
      _showContinueButton = _code.length == 4;
    });
  }

  void _onContinuePressed() async {
    if (_code.length == 4) {
      // Firebase ile doğrulama kodunu kontrol et
      final isVerified = await _authService.verifyPhoneCode(_code);
      
      if (isVerified) {
        // Kullanıcı bilgilerini Firebase'e kaydet
        final userDataController = Get.find<UserDataController>();
        await _authService.updateUserProfile(
          firstName: userDataController.firstName,
          lastName: userDataController.lastName,
          username: userDataController.username,
          email: userDataController.email,
          password: userDataController.password,
        );
        
        // Kullanıcı verilerini temizle
        userDataController.clearData();
        
        Get.to(() => const LocationScreen());
      }
    }
  }

  void _onNumberPressed(String number) {
    for (int i = 0; i < 4; i++) {
      if (_controllers[i].text.isEmpty) {
        _controllers[i].text = number;
        if (i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
        break;
      }
    }
  }

  void _onBackspacePressed() {
    for (int i = 3; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].text = '';
        if (i > 0) {
          _focusNodes[i - 1].requestFocus();
        }
        break;
      }
    }
  }

  void _onResendCode() async {
    // Telefon numarasını al ve yeni kod gönder
    final phoneNumber = Get.find<PhoneInputController>().phoneNumber;
    if (phoneNumber.isNotEmpty) {
      await _authService.sendPhoneVerificationCode(phoneNumber);
      
      for (int i = 0; i < 4; i++) {
        _controllers[i].clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  Widget _buildKeypadButton(String text, {String? subtitle, VoidCallback? onPressed, bool isSpecial = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isSpecial ? Colors.grey : Colors.black,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Telefon doğrulama',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Telefonunuza gönderilen 4 haneli doğrulama kodunu girin',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF53B175).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF53B175).withOpacity(0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF53B175),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Test sürümü: Doğrulama kodu 0000',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF53B175),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Doğrulama Kodu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Code Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              _focusNodes[index + 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Resend Code Link
                  GestureDetector(
                    onTap: _onResendCode,
                    child:                          const Text(
                           'SMS kodunu yeniden gönder',
                           style: TextStyle(
                             color: Color(0xFF53B175),
                             fontSize: 14,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Continue Button
            _showContinueButton
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Obx(() => GestureDetector(
                      onTap: _authService.isLoading ? null : _onContinuePressed,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF53B175),
                          shape: BoxShape.circle,
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
                            : const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                    )),
                  ),
                )
              : const SizedBox.shrink(),
            
            const SizedBox(height: 40),
            
            // Keypad
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Row 1: 1, 2, 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('1', onPressed: () => _onNumberPressed('1')),
                      _buildKeypadButton('2', subtitle: 'ABC', onPressed: () => _onNumberPressed('2')),
                      _buildKeypadButton('3', subtitle: 'DEF', onPressed: () => _onNumberPressed('3')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Row 2: 4, 5, 6
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('4', subtitle: 'GHI', onPressed: () => _onNumberPressed('4')),
                      _buildKeypadButton('5', subtitle: 'JKL', onPressed: () => _onNumberPressed('5')),
                      _buildKeypadButton('6', subtitle: 'MNO', onPressed: () => _onNumberPressed('6')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Row 3: 7, 8, 9
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('7', subtitle: 'PQRS', onPressed: () => _onNumberPressed('7')),
                      _buildKeypadButton('8', subtitle: 'TUV', onPressed: () => _onNumberPressed('8')),
                      _buildKeypadButton('9', subtitle: 'WXYZ', onPressed: () => _onNumberPressed('9')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Row 4: Special, 0, Backspace
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('+*#', isSpecial: true),
                      _buildKeypadButton('0', onPressed: () => _onNumberPressed('0')),
                      GestureDetector(
                        onTap: _onBackspacePressed,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

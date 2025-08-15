import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_data_controller.dart';
import 'verification_screen.dart';
import 'signup_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final PhoneInputController _phoneController = Get.put(PhoneInputController());
  final TextEditingController _phoneTextController = TextEditingController();
  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();
    _phoneTextController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneTextController.removeListener(_onPhoneChanged);
    _phoneTextController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    setState(() {
      _showContinueButton = _phoneTextController.text.length >= 10;
    });
  }

  void _onContinuePressed() {
    if (_phoneTextController.text.length >= 10) {
      // Telefon numarasını controller'a kaydet
      _phoneController.updatePhoneNumber('+90${_phoneTextController.text}');
      Get.to(() => const SignupScreen());
    }
  }

  void _onNumberPressed(String number) {
    if (_phoneTextController.text.length < 10) {
      setState(() {
        _phoneTextController.text += number;
      });
    }
  }

  void _onBackspacePressed() {
    if (_phoneTextController.text.isNotEmpty) {
      setState(() {
        _phoneTextController.text = _phoneTextController.text.substring(0, _phoneTextController.text.length - 1);
      });
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
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Telefon numaranızı girin',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Telefon Numarası',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Phone Input Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Turkey Flag
                      const Text(
                        '🇹🇷',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      
                      // Country Code
                      const Text(
                        '+90',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                                             // Phone Number Input
                       Expanded(
                         child: TextField(
                           controller: _phoneTextController,
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '5XX XXX XX XX',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Continue Button
          if (_showContinueButton)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _onContinuePressed,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF53B175),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          
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
    );
  }
}

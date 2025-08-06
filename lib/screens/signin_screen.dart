import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
                                // Upper part with background image (40% of screen)
           Expanded(
             flex: 4,
             child: Container(
               width: double.infinity,
               decoration: const BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('assets/images/mask_group.png'),
                   fit: BoxFit.cover,
                 ),
               ),
             ),
           ),
           
           // Lower part with white background (60% of screen)
           Expanded(
             flex: 6,
             child: Container(
               color: Colors.white,
               padding: const EdgeInsets.all(24.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  // Main Title - Left aligned
                  const Text(
                    'KOBİZON ile market\nalışverişinizi yapın',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.left,
                  ),
                
                  const SizedBox(height: 32),
                  
                  // Phone Number Input - Horizontal line style
                  Row(
                    children: [
                      // Country Flag and Code
                      Container(
                        width: 32,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            '🇹🇷',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '+90',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Telefon numaranızı girin',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  
                  // Horizontal line under phone input
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                    margin: const EdgeInsets.only(top: 8),
                  ),
                
                  const SizedBox(height: 24),
                  
                  // Social Media Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Veya sosyal medya ile bağlanın',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Google Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Google ile devam et',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Facebook Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1877F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'f',
                              style: TextStyle(
                                color: Color(0xFF1877F2),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Facebook ile devam et',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                                     ),
                   
                   const SizedBox(height: 20),
                 ],
               ),
             ),
           ),
         ],
       ),
     );
   }
} 
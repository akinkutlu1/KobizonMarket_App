import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
             appBar: AppBar(
         title: const Text('Profil'),
         centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit profile functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF53B175),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                                     // User Name
                   const Text(
                     'Ahmet Yılmaz',
                     style: TextStyle(
                       fontSize: 24,
                       fontWeight: FontWeight.bold,
                       color: Colors.black87,
                     ),
                   ),
                   
                   const SizedBox(height: 4),
                   
                   // User Email
                   const Text(
                     'ahmet.yilmaz@example.com',
                     style: TextStyle(
                       fontSize: 16,
                       color: Colors.grey,
                     ),
                   ),
                  
                  const SizedBox(height: 16),
                  
                                     // Stats Row
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       _buildStatItem('Siparişler', '12'),
                       _buildStatItem('Favoriler', '8'),
                       _buildStatItem('Yorumlar', '5'),
                     ],
                   ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
                         // Menu Items
             _buildMenuItem(
               icon: Icons.shopping_bag_outlined,
               title: 'Siparişlerim',
               subtitle: 'Sipariş durumunu kontrol edin',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.favorite_border,
               title: 'Favoriler',
               subtitle: 'Kaydedilen ürünleriniz',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.location_on_outlined,
               title: 'Teslimat Adresi',
               subtitle: 'Adreslerinizi yönetin',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.payment_outlined,
               title: 'Ödeme Yöntemleri',
               subtitle: 'Ödeme seçeneklerinizi yönetin',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.notifications_outlined,
               title: 'Bildirimler',
               subtitle: 'Bildirimlerinizi yönetin',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.security_outlined,
               title: 'Gizlilik & Güvenlik',
               subtitle: 'Gizlilik ayarlarınızı yönetin',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.help_outline,
               title: 'Yardım & Destek',
               subtitle: 'Yardım alın ve destek ile iletişime geçin',
               onTap: () {},
             ),
             
             _buildMenuItem(
               icon: Icons.info_outline,
               title: 'Hakkında',
               subtitle: 'Uygulama versiyonu ve bilgileri',
               onTap: () {},
             ),
            
            const SizedBox(height: 24),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logout functionality
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                                 child: const Text(
                   'Çıkış Yap',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 16,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF53B175),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF53B175),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
         showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: const Text('Çıkış Yap'),
         content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
         actions: [
           TextButton(
             onPressed: () {
               Navigator.of(context).pop();
             },
             child: const Text('İptal'),
           ),
           TextButton(
             onPressed: () {
               Navigator.of(context).pop();
               // Perform logout
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                   content: Text('Başarıyla çıkış yapıldı'),
                 ),
               );
             },
             child: const Text(
               'Çıkış Yap',
               style: TextStyle(color: Colors.red),
             ),
           ),
         ],
       ),
     );
  }
} 
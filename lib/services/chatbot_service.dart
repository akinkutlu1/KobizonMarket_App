import 'dart:math';

class ChatbotService {
  // Beslenme veritabanı
  static final Map<String, Map<String, dynamic>> nutritionDatabase = {
    'elma': {
      'kalori': 95,
      'protein': 0.5,
      'karbonhidrat': 25,
      'lif': 4.4,
      'vitamin_c': 8.4,
      'vitamin_k': 2.2,
      'potasyum': 195,
      'açıklama': 'Bağışıklık sistemini güçlendirir, sindirim dostu, antioksidan açısından zengin.',
      'günlük_porsiyon': '1-2 adet',
      'kategori': 'meyve',
      'renk': 'kırmızı/yeşil',
    },
    'muz': {
      'kalori': 105,
      'protein': 1.3,
      'karbonhidrat': 27,
      'lif': 3.1,
      'potasyum': 422,
      'vitamin_b6': 0.4,
      'vitamin_c': 10.3,
      'açıklama': 'Potasyum açısından zengin, enerji verici, kas kramplarını önler.',
      'günlük_porsiyon': '1 adet',
      'kategori': 'meyve',
      'renk': 'sarı',
    },
    'brokoli': {
      'kalori': 31,
      'protein': 2.5,
      'karbonhidrat': 6,
      'lif': 2.6,
      'vitamin_c': 81.2,
      'vitamin_k': 92.5,
      'folat': 57,
      'açıklama': 'Kanser önleyici özellikler, kemik sağlığı, bağışıklık güçlendirici.',
      'günlük_porsiyon': '1 su bardağı',
      'kategori': 'sebze',
      'renk': 'yeşil',
    },
    'havuç': {
      'kalori': 41,
      'protein': 0.9,
      'karbonhidrat': 10,
      'lif': 2.8,
      'vitamin_a': 835,
      'vitamin_k': 8.1,
      'potasyum': 320,
      'açıklama': 'Göz sağlığı için mükemmel, cilt sağlığını destekler, antioksidan.',
      'günlük_porsiyon': '1 orta boy',
      'kategori': 'sebze',
      'renk': 'turuncu',
    },
    'domates': {
      'kalori': 22,
      'protein': 1.1,
      'karbonhidrat': 5,
      'lif': 1.2,
      'vitamin_c': 13.7,
      'vitamin_k': 7.9,
      'likopen': 'yüksek',
      'açıklama': 'Kalp sağlığını destekler, cilt sağlığı, antioksidan açısından zengin.',
      'günlük_porsiyon': '1 orta boy',
      'kategori': 'sebze',
      'renk': 'kırmızı',
    },
    'ıspanak': {
      'kalori': 23,
      'protein': 2.9,
      'karbonhidrat': 4,
      'lif': 2.2,
      'vitamin_a': 469,
      'vitamin_c': 28.1,
      'demir': 2.7,
      'açıklama': 'Demir açısından zengin, kas gücünü artırır, göz sağlığı.',
      'günlük_porsiyon': '1 su bardağı',
      'kategori': 'sebze',
      'renk': 'yeşil',
    },
    'portakal': {
      'kalori': 62,
      'protein': 1.2,
      'karbonhidrat': 15,
      'lif': 3.1,
      'vitamin_c': 69.7,
      'folat': 30,
      'potasyum': 237,
      'açıklama': 'C vitamini deposu, bağışıklık güçlendirici, soğuk algınlığına karşı koruyucu.',
      'günlük_porsiyon': '1 adet',
      'kategori': 'meyve',
      'renk': 'turuncu',
    },
    'çilek': {
      'kalori': 49,
      'protein': 1.0,
      'karbonhidrat': 12,
      'lif': 3.0,
      'vitamin_c': 84.7,
      'folat': 24,
      'manganez': 0.4,
      'açıklama': 'Antioksidan açısından zengin, cilt sağlığı, kalp sağlığını destekler.',
      'günlük_porsiyon': '1 su bardağı',
      'kategori': 'meyve',
      'renk': 'kırmızı',
    },
    'karnabahar': {
      'kalori': 25,
      'protein': 1.9,
      'karbonhidrat': 5,
      'lif': 2.0,
      'vitamin_c': 48.2,
      'vitamin_k': 15.5,
      'folat': 57,
      'açıklama': 'Sindirim dostu, anti-inflamatuar, beyin sağlığını destekler.',
      'günlük_porsiyon': '1 su bardağı',
      'kategori': 'sebze',
      'renk': 'beyaz',
    },
    'kivi': {
      'kalori': 42,
      'protein': 0.8,
      'karbonhidrat': 10,
      'lif': 2.1,
      'vitamin_c': 64.0,
      'vitamin_k': 40.3,
      'potasyum': 215,
      'açıklama': 'C vitamini açısından zengin, sindirim dostu, uyku kalitesini artırır.',
      'günlük_porsiyon': '1 adet',
      'kategori': 'meyve',
      'renk': 'kahverengi',
    },
  };

  // Gelişmiş kurallar ve cevaplar
  static final Map<String, List<String>> ruleResponses = {
    'kalori': [
      'Kalori bilgisi için lütfen ürün adını belirtin. Örneğin: "Elma kaç kalori?"',
      'Hangi ürünün kalorisini öğrenmek istiyorsunuz? Elma, muz, brokoli gibi...',
      'Ürün adını söylerseniz kalori bilgisini verebilirim. Mevcut ürünler: elma, muz, brokoli, havuç, domates, ıspanak, portakal, çilek, karnabahar, kivi',
    ],
    'sağlık': [
      'Sağlıklı beslenme için günde 5 porsiyon meyve-sebze tüketmeyi unutmayın! 🥗',
      'Renkli beslenme sağlıklı beslenmedir. Farklı renkte sebze-meyveler tüketin. 🌈',
      'Su içmeyi unutmayın! Günde en az 8 bardak su için. 💧',
      'Düzenli egzersiz yapın ve yeterli uyku alın. 🏃‍♀️',
    ],
    'diyet': [
      'Kilo vermek için düşük kalorili, yüksek lifli sebzeler tercih edin. 🥬',
      'Protein açısından zengin besinler tokluk hissini artırır. 🥩',
      'Şekerli içecekler yerine su veya bitki çayları için. 🍵',
      'Porsiyon kontrolü yapın ve yavaş yemek yiyin. ⏰',
    ],
    'vitamin': [
      'C vitamini için portakal, çilek, kivi tüketebilirsiniz. 🍊',
      'A vitamini için havuç, ıspanak, brokoli önerilir. 🥕',
      'K vitamini için yeşil yapraklı sebzeler mükemmel. 🥬',
      'B vitamini için tam tahıllı ürünler ve et tüketin. 🌾',
    ],
    'merhaba': [
      'Merhaba! Ben KOBİZBOT, sağlıklı beslenme konusunda size yardımcı olmaya hazırım. 🥗',
      'Selam! Hangi ürün hakkında bilgi almak istiyorsunuz? Elma, brokoli, havuç gibi...',
      'Merhaba! Beslenme sorularınızı yanıtlamaya hazırım. Kalori, vitamin, sağlık faydaları hakkında sorularınızı bekliyorum!',
    ],
    'teşekkür': [
      'Rica ederim! Başka sorularınız varsa yardımcı olmaktan mutluluk duyarım. 😊',
      'Ne demek! Sağlıklı beslenme yolculuğunuzda yanınızdayım. 🥗',
      'Rica ederim! Sağlıklı kalın ve iyi beslenin! 💪',
    ],
    'nasılsın': [
      'İyiyim, teşekkür ederim! Size nasıl yardımcı olabilirim? 😊',
      'Harika! Sağlıklı beslenme konusunda sorularınızı bekliyorum. 🥗',
      'Çok iyiyim! Hangi ürün hakkında bilgi almak istiyorsunuz?',
    ],
    'görüşürüz': [
      'Görüşmek üzere! Sağlıklı beslenmeye devam edin. 👋',
      'Hoşça kalın! Sağlıklı kalın ve iyi beslenin. 🥗',
      'Görüşürüz! Başka sorularınız olursa buradayım. 😊',
    ],
    'yardım': [
      'Size nasıl yardımcı olabilirim? Kalori, vitamin, sağlık faydaları hakkında sorularınızı yanıtlayabilirim. 🥗',
      'Hangi konuda yardıma ihtiyacınız var? Ürün bilgileri, beslenme önerileri verebilirim.',
      'Yardım için buradayım! Hangi ürün hakkında bilgi almak istiyorsunuz?',
    ],
  };

  // Rastgele cevap seçici
  static String _getRandomResponse(List<String> responses) {
    final random = Random();
    return responses[random.nextInt(responses.length)];
  }

  // Gelişmiş chatbot fonksiyonu
  static String getResponse(String userMessage) {
    final message = userMessage.toLowerCase().trim();
    
    // Özel durumlar
    if (message.contains('nasılsın') || message.contains('nasıl gidiyor')) {
      return _getRandomResponse(ruleResponses['nasılsın']!);
    }
    
    if (message.contains('görüşürüz') || message.contains('hoşça kal') || message.contains('bye')) {
      return _getRandomResponse(ruleResponses['görüşürüz']!);
    }
    
    if (message.contains('yardım') || message.contains('ne yapabilirsin')) {
      return _getRandomResponse(ruleResponses['yardım']!);
    }
    
    if (message.contains('merhaba') || message.contains('selam') || message.contains('hi')) {
      return _getRandomResponse(ruleResponses['merhaba']!);
    }
    
    if (message.contains('teşekkür') || message.contains('sağol') || message.contains('thanks')) {
      return _getRandomResponse(ruleResponses['teşekkür']!);
    }
    
    // Ürün arama (daha gelişmiş)
    for (var entry in nutritionDatabase.entries) {
      if (message.contains(entry.key)) {
        return _getProductInfo(entry.key, entry.value, message);
      }
    }
    
    // Kural tabanlı cevaplar
    for (var rule in ruleResponses.entries) {
      if (message.contains(rule.key)) {
        return _getRandomResponse(rule.value);
      }
    }
    
    // Özel sorular
    if (message.contains('hangi') && message.contains('meyve')) {
      return 'Meyveler arasında elma, muz, portakal, çilek, kivi bulunur. Hangi meyve hakkında bilgi almak istiyorsunuz? 🍎🍌🍊';
    }
    
    if (message.contains('hangi') && message.contains('sebze')) {
      return 'Sebzeler arasında brokoli, havuç, domates, ıspanak, karnabahar bulunur. Hangi sebze hakkında bilgi almak istiyorsunuz? 🥬🥕🍅';
    }
    
    if (message.contains('en sağlıklı')) {
      return 'En sağlıklı besinler: Brokoli (kanser önleyici), Ispanak (demir açısından zengin), Havuç (göz sağlığı), Elma (bağışıklık güçlendirici). Hangi birini detaylı öğrenmek istersiniz? 🥬🥕🍎';
    }
    
    if (message.contains('en düşük kalori')) {
      return 'En düşük kalorili besinler: Karnabahar (25 kalori), Domates (22 kalori), Ispanak (23 kalori), Brokoli (31 kalori). Hangi birini detaylı öğrenmek istersiniz? 🥬🍅';
    }
    
    if (message.contains('c vitamini')) {
      return 'C vitamini açısından zengin besinler: Portakal (69.7mg), Çilek (84.7mg), Kivi (64mg), Brokoli (81.2mg). Hangi birini detaylı öğrenmek istersiniz? 🍊🍓🥝';
    }
    
    // Varsayılan cevap
    return _getDefaultResponse();
  }

  // Ürün bilgisi oluşturma
  static String _getProductInfo(String productName, Map<String, dynamic> info, String message) {
    final capitalizedName = productName[0].toUpperCase() + productName.substring(1);
    
    if (message.contains('kalori')) {
      return '$capitalizedName ${info['kalori']} kalori içerir. ${info['açıklama']}';
    }
    
    if (message.contains('vitamin')) {
      final vitamins = <String>[];
      if (info.containsKey('vitamin_c')) vitamins.add('C vitamini');
      if (info.containsKey('vitamin_a')) vitamins.add('A vitamini');
      if (info.containsKey('vitamin_k')) vitamins.add('K vitamini');
      if (info.containsKey('vitamin_b6')) vitamins.add('B6 vitamini');
      
      if (vitamins.isNotEmpty) {
        return '$capitalizedName ${vitamins.join(', ')} açısından zengindir. ${info['açıklama']}';
      }
    }
    
    if (message.contains('sağlık') || message.contains('fayda') || message.contains('yarar')) {
      return '$capitalizedName: ${info['açıklama']}';
    }
    
    if (message.contains('günlük') || message.contains('porsiyon') || message.contains('ne kadar')) {
      return '$capitalizedName için önerilen günlük porsiyon: ${info['günlük_porsiyon']}. ${info['açıklama']}';
    }
    
    // Genel ürün bilgisi
    return '$capitalizedName (${info['kalori']} kalori): ${info['açıklama']}';
  }

  // Gelişmiş varsayılan cevap
  static String _getDefaultResponse() {
    final responses = [
      'Bu konuda size yardımcı olabilmem için daha spesifik bir soru sorabilir misiniz? Örneğin: "Elma kaç kalori?" veya "Brokoli sağlıklı mı?" 🥗',
      'Hangi ürün hakkında bilgi almak istiyorsunuz? Elma, muz, brokoli, havuç, domates, ıspanak, portakal, çilek, karnabahar, kivi gibi... 🍎🥬',
      'Kalori, vitamin, sağlık faydaları gibi konularda sorularınızı yanıtlayabilirim. Hangi konuda yardıma ihtiyacınız var? 💪',
      'Meyve ve sebzeler hakkında sorularınızı bekliyorum! "En sağlıklı besinler neler?" gibi sorular da sorabilirsiniz. 🥗',
      'Size nasıl yardımcı olabilirim? Ürün bilgileri, beslenme önerileri, kalori hesaplamaları yapabilirim. 🍎🥬',
    ];
    
    return _getRandomResponse(responses);
  }

  // Tüm ürünleri listele
  static List<String> getAllProducts() {
    return nutritionDatabase.keys.toList();
  }

  // Kategoriye göre ürün listesi
  static List<String> getProductsByCategory(String category) {
    return nutritionDatabase.entries
        .where((entry) => entry.value['kategori'] == category)
        .map((entry) => entry.key)
        .toList();
  }
}

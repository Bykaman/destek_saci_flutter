import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HakkindaSayfasi extends StatefulWidget {
  const HakkindaSayfasi({super.key});

  @override
  State<HakkindaSayfasi> createState() => _HakkindaSayfasiState();
}

class _HakkindaSayfasiState extends State<HakkindaSayfasi> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = "${info.version}+${info.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hakkında"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PVC Destek Sacı Hesaplama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 12),
            const Text(
              'Bu uygulama, galvanizli yassı çelik sacından üretilen PVC destek sacı profilleri '
              '(U, C, G ve Açık Kutu) için yaklaşık ağırlık, birim fiyat ve toplam maliyet '
              'hesaplamalarını pratik biçimde yapmanıza yardımcı olmak amacıyla hazırlanmıştır.',
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),

            // Başlık: Önemli Uyarılar (sadece baş harfler büyük), sade siyah
            const Text(
              'Önemli Uyarılar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Uyarı metni: sade siyah
            const Text(
              'Hesaplama sonuçları yalnızca bilgilendirme amaçlıdır. '
              'Çıkan sonuçların doğruluğunu kullanıcıların mutlaka kendilerinin kontrol etmesi gerekmektedir. '
              'Hesaplama sonuçlarından doğabilecek her türlü risk ve zarardan kullanıcı sorumludur. '
              'Uygulama sahibi hiçbir şekilde sorumluluk kabul etmez.',
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                _version.isNotEmpty
                    ? "Sürüm: $_version — Tüm hakları saklıdır."
                    : "Sürüm bilgisi yükleniyor...",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

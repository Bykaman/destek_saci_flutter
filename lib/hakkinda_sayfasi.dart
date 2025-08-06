import 'package:flutter/material.dart';

class HakkindaSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hakkında'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PVC Destek Sacı Hesaplama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Bu uygulama, PVC pencere sistemlerinde kullanılan destek sacı profillerinin 1 mtül ağırlık ve fiyat hesaplamasını yapar.',
            ),
            SizedBox(height: 16),
            Text(
              'Kullanım:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• Profil tipini seçin\n• Ölçüleri ve birim fiyatı girin\n• HESAPLA butonuna basın'),
            SizedBox(height: 16),
            Text(
              'Sürüm: v0.1',
              style: TextStyle(color: Colors.grey),
            ),
            Spacer(),
            Center(
              child: Text(
                'Tüm hakları saklıdır.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}

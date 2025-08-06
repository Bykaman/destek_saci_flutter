import 'package:flutter/material.dart';

class UProfilSayfasi extends StatefulWidget {
  @override
  _UProfilSayfasiState createState() => _UProfilSayfasiState();
}

class _UProfilSayfasiState extends State<UProfilSayfasi> {
  final TextEditingController _etKalinlikController = TextEditingController();
  final TextEditingController _kenar1Controller = TextEditingController();
  final TextEditingController _tabanController = TextEditingController();
  final TextEditingController _kenar2Controller = TextEditingController();
  final TextEditingController _fiyatController = TextEditingController();

  double toplamGenislik = 0.0;
  double netGenislik = 0.0;
  double agirlik = 0.0;
  double fiyat = 0.0;

  void _hesapla() {
    setState(() {
      final double etKalinlik = double.tryParse(_etKalinlikController.text.replaceAll(',', '.')) ?? 0.0;
      final double kenar1 = double.tryParse(_kenar1Controller.text.replaceAll(',', '.')) ?? 0.0;
      final double taban = double.tryParse(_tabanController.text.replaceAll(',', '.')) ?? 0.0;
      final double kenar2 = double.tryParse(_kenar2Controller.text.replaceAll(',', '.')) ?? 0.0;
      final double fiyatBirim = double.tryParse(_fiyatController.text.replaceAll(',', '.')) ?? 0.0;

      toplamGenislik = kenar1 + taban + kenar2; // cm
      double kosePayi = etKalinlik * 4; // 2 köşe × 2
      netGenislik = toplamGenislik - kosePayi; // cm

      agirlik = etKalinlik * netGenislik * 7.85 / 1000; // kg
      fiyat = agirlik * fiyatBirim;
    });
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData? icon, String? hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: Text('U PROFİL Hesaplama'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_etKalinlikController, 'Et Kalınlığı (mm)', Icons.straighten, 'Örn: 1.20'),
            _buildTextField(_kenar1Controller, '1. Kenar (cm)', Icons.horizontal_rule, 'Örn: 23'),
            _buildTextField(_tabanController, 'Taban (cm)', Icons.horizontal_rule, 'Örn: 23'),
            _buildTextField(_kenar2Controller, '2. Kenar (cm)', Icons.horizontal_rule, 'Örn: 23'),
            _buildTextField(_fiyatController, 'Kilo Birim Fiyatı (TL)', Icons.currency_lira, null),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _hesapla,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.calculate),
              label: Text('HESAPLA', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 24.0),
            Card(
              color: Colors.grey.shade100,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Toplam Genişlik (cm): ${toplamGenislik.toStringAsFixed(2)}'),
                    Text('Net Sac Genişliği (cm): ${netGenislik.toStringAsFixed(2)}'),
                    Text('1 mtül Ağırlık (kg): ${agirlik.toStringAsFixed(4)}'),
                    Text('1 mtül Fiyat (TL): ${fiyat.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

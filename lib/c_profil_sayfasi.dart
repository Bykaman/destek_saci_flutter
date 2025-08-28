import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CProfilSayfasi extends StatefulWidget {
  const CProfilSayfasi({super.key});
  @override
  State<CProfilSayfasi> createState() => _CProfilSayfasiState();
}

class _CProfilSayfasiState extends State<CProfilSayfasi> {
  // Girişler (mm ve ₺/kg) — BAŞLANGIÇTA BOŞ
  final _et      = TextEditingController(); // mm
  final _k1      = TextEditingController(); // mm
  final _k2      = TextEditingController(); // mm
  final _taban   = TextEditingController(); // mm
  final _k4      = TextEditingController(); // mm
  final _k5      = TextEditingController(); // mm
  final _fiyatKg = TextEditingController(); // ₺/kg

  // Odaklar: yalnız odaktayken “Örn:” ipucu için
  final _fEt = FocusNode();
  final _fK1 = FocusNode();
  final _fK2 = FocusNode();
  final _fTaban = FocusNode();
  final _fK4 = FocusNode();
  final _fK5 = FocusNode();
  final _fFiyat = FocusNode();

  // Sonuçlar
  double netGenislik = 0.0;    // mm
  double kgPerMeter = 0.0;     // kg/mtül
  double pricePerMeter = 0.0;  // ₺/mtül

  // Detaylı
  static const int _STD_BOY_MM = 6000;
  final _boyMm = TextEditingController(text: '6000');
  final _adet  = TextEditingController(text: '100');
  bool _detay = true, _stdBoy = true;

  double _toplamMetre = 0.0, _toplamKilo = 0.0, _toplamTl = 0.0;

  // Stil/Renk (U sayfasıyla aynı)
  final Color _pageBg = const Color(0xFFF3F4F6);
  final Color _cardFill = const Color(0xFFEFF6FF); // ana & detay sonuçlar aynı
  final BorderRadius _radius = BorderRadius.circular(12);
  final _shadow = const [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))
  ];

  // Yardımcılar
  double _p(String v) => double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
  String _fmtFixed(num x, int frac) =>
      NumberFormat('#,##0.${'0' * frac}', 'tr_TR').format(x);
  String _fmtCurr(num x) =>
      '${NumberFormat('#,##0.00', 'tr_TR').format(x)} ₺';

  // Odakta ve boşsa “Örn:” ipucunu gösteren alan
  Widget _numField({
    required TextEditingController c,
    required FocusNode f,
    required String label,
    required String example, // "Örn: 25" vb.
  }) {
    final showHint = f.hasFocus && c.text.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        focusNode: f,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: showHint ? example : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: _radius),
          focusedBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: Colors.indigo.shade400, width: 1.6),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        onSubmitted: (_) => _hesapla(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (final f in [_fEt, _fK1, _fK2, _fTaban, _fK4, _fK5, _fFiyat]) {
      f.addListener(() => setState(() {}));
    }
    _hesapla(); // boşken 0 değerler
  }

  @override
  void dispose() {
    _et.dispose();
    _k1.dispose();
    _k2.dispose();
    _taban.dispose();
    _k4.dispose();
    _k5.dispose();
    _fiyatKg.dispose();
    _boyMm.dispose();
    _adet.dispose();
    _fEt.dispose();
    _fK1.dispose();
    _fK2.dispose();
    _fTaban.dispose();
    _fK4.dispose();
    _fK5.dispose();
    _fFiyat.dispose();
    super.dispose();
  }

  void _hesapla() {
    final et = _p(_et.text);        // mm
    final k1 = _p(_k1.text);        // mm
    final k2 = _p(_k2.text);        // mm
    final tb = _p(_taban.text);     // mm
    final k4 = _p(_k4.text);        // mm
    final k5 = _p(_k5.text);        // mm
    final fiyatKg = _p(_fiyatKg.text);

    final toplam = k1 + k2 + tb + k4 + k5; // mm
    final kosePayi = et * 8;               // 4 köşe × 2 pay
    netGenislik = (toplam - kosePayi).clamp(0, double.infinity);

    // kg/mtül = 0.00785 × et(mm) × net(mm)
    kgPerMeter    = 0.00785 * et * netGenislik;
    pricePerMeter = kgPerMeter * fiyatKg;

    _hesaplaDetay();
    setState(() {});
  }

  void _hesaplaDetay() {
    if (!_detay) {
      _toplamMetre = 0;
      _toplamKilo = 0;
      _toplamTl = 0;
      setState(() {});
      return;
    }
    final adet = _p(_adet.text);
    final boy  = _stdBoy ? _STD_BOY_MM.toDouble() : _p(_boyMm.text);
    final metre = (boy * adet) / 1000.0; // mm -> m

    _toplamMetre = metre;
    _toplamKilo  = kgPerMeter * metre;
    _toplamTl    = pricePerMeter * metre;
    setState(() {});
  }

  Widget _resultCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardFill, borderRadius: _radius, boxShadow: _shadow),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Net Sac Genişliği (mm): ${_fmtFixed(netGenislik, 2)}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        Text('1 mtül Ağırlık (kg): ${_fmtFixed(kgPerMeter, 6)}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        Text('1 mtül Fiyat (₺): ${_fmtFixed(pricePerMeter, 6)}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _outlinedBlock({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _radius,
        border: Border.all(color: Colors.indigo.shade200, width: 1.4),
        boxShadow: _shadow,
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }

  Widget _detayBolumu() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: !_detay
          ? const SizedBox.shrink()
          : Column(
              key: const ValueKey('detayAcik'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _outlinedBlock(
                  child: CheckboxListTile(
                    dense: false,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Standart 1 boy (6000 mm)',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    value: _stdBoy,
                    onChanged: (v) {
                      setState(() => _stdBoy = v ?? true);
                      if (_stdBoy) _boyMm.text = '6000';
                      _hesaplaDetay();
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _outlinedBlock(
                        child: TextField(
                          controller: _boyMm,
                          enabled: !_stdBoy,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: '1 adet (boy) [mm]',
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => _hesaplaDetay(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _outlinedBlock(
                        child: TextField(
                          controller: _adet,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Adet (boy sayısı)',
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => _hesaplaDetay(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _cardFill, borderRadius: _radius, boxShadow: _shadow),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Detaylı Sonuçlar',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Toplam uzunluk: ${_fmtFixed(_toplamMetre, 0)} m',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('Toplam kilo: ${_fmtFixed(_toplamKilo, 2)} kg',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('Toplam maliyet: ${_fmtCurr(_toplamTl)}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        'Hesap: 1 mtül = ${_fmtFixed(kgPerMeter, 6)} kg, ${_fmtFixed(pricePerMeter, 6)} ₺',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text('C PROFİL Hesaplama'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Hintler: yalnız odaktayken
            _numField(c: _et,      f: _fEt,    label: 'Et Kalınlığı (mm)', example: 'Örn: 1,20'),
            _numField(c: _k1,      f: _fK1,    label: '1. Kenar (mm)',     example: 'Örn: 8'),
            _numField(c: _k2,      f: _fK2,    label: '2. Kenar (mm)',     example: 'Örn: 25'),
            _numField(c: _taban,   f: _fTaban, label: 'Taban (mm)',        example: 'Örn: 40'),
            _numField(c: _k4,      f: _fK4,    label: '4. Kenar (mm)',     example: 'Örn: 25'),
            _numField(c: _k5,      f: _fK5,    label: '5. Kenar (mm)',     example: 'Örn: 8'),
            _numField(c: _fiyatKg, f: _fFiyat, label: 'Kilo Birim Fiyatı (₺/kg)', example: 'Örn: 45'),

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _hesapla,
              icon: const Icon(Icons.calculate),
              label: const Text('HESAPLA'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: _radius),
                elevation: 3,
              ),
            ),

            const SizedBox(height: 16),
            _resultCard(),

            const SizedBox(height: 16),
            _outlinedBlock(
              child: SwitchListTile(
                title: const Text('Detaylı hesaplama',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                value: _detay,
                onChanged: (v) { setState(() => _detay = v); _hesaplaDetay(); },
              ),
            ),

            const SizedBox(height: 12),
            _detayBolumu(),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'u_profil_sayfasi.dart';
import 'c_profil_sayfasi.dart';
import 'g_profil_sayfasi.dart';
import 'acik_kutu_sayfasi.dart';
import 'hakkinda_sayfasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PVC Destek Sacı Hesaplama',
      theme: ThemeData(fontFamily: 'Arial'),
      home: const AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = "${info.version}+${info.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PVC DESTEK SACI HESAPLAMA"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HakkindaSayfasi()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5EFF9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'PVC DESTEK SACI HESAPLAMA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,
                  children: [
                    _buildCard(
                      context,
                      'assets/icons/u_profil.png',
                      'U PROFİL',
                      () => const UProfilSayfasi(),
                    ),
                    _buildCard(
                      context,
                      'assets/icons/c_profil.png',
                      'C PROFİL',
                      () => const CProfilSayfasi(),
                    ),
                    _buildCard(
                      context,
                      'assets/icons/g_profil.png',
                      'G PROFİL',
                      () => const GProfilSayfasi(),
                    ),
                    _buildCard(
                      context,
                      'assets/icons/acik_kutu.png',
                      'AÇIK KUTU\nPROFİL',
                      () => const AcikKutuSayfasi(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _version.isNotEmpty
                    ? "Sürüm: $_version — Tüm hakları saklıdır."
                    : "Sürüm bilgisi yükleniyor...",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String img,
    String title,
    Widget Function() page,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(img, height: 80),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

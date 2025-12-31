import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'password_generator_page.dart';
import 'add_password_sheet.dart';
import 'auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const VaultListBody(),
    const PasswordGeneratorPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Kasa'),
            BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Üretici'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
          ],
        ),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).cardColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => const AddPasswordSheet(),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              )
            : null,
      ),
    );
  }
}

class VaultListBody extends StatefulWidget {
  const VaultListBody({super.key});

  @override
  State<VaultListBody> createState() => _VaultListBodyState();
}

class _VaultListBodyState extends State<VaultListBody> {
  String _searchQuery = "";
  bool _showReport = false;
  int _riskCount = 0;

  @override
  void initState() {
    super.initState();
    _checkDailyReportStatus();
  }

  // Günde bir kez raporu gösterip göstermeyeceğimizi kontrol eder
  Future<void> _checkDailyReportStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String? lastCheck = prefs.getString('last_security_check');

    if (lastCheck != today) {
      setState(() => _showReport = true);
      await prefs.setString('last_security_check', today);
    }
  }

  // Güvenlik taraması yapan mantık
  void _performAudit(List<QueryDocumentSnapshot> docs) {
    int weak = 0;
    Map<String, int> counts = {};
    for (var doc in docs) {
      String pass = doc['password'];
      if (pass.length < 8) weak++;
      counts[pass] = (counts[pass] ?? 0) + 1;
    }
    int reused = counts.values.where((c) => c > 1).length;
    
    // Değişiklik varsa state'i güncelle (Sonsuz döngü olmaması için microtask ile)
    if (_riskCount != (weak + reused)) {
      Future.microtask(() {
        if (mounted) setState(() => _riskCount = weak + reused);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- 1. ARAMA ÇUBUĞU ---
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Şifrelerde ara...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
        ),

        // --- 2. GÜNLÜK GÜVENLİK RAPORU (ANIMASYONLU) ---
        if (_showReport && _riskCount > 0 && _searchQuery.isEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.gpp_maybe, color: Colors.redAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Kuzen, bugün için $_riskCount güvenlik riski buldum. Bir göz at istersen.",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () => setState(() => _showReport = false),
                )
              ],
            ),
          ),

        // --- 3. LİSTE ALANI VE BOŞ KASA ---
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('passwords')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text("Hata!"));
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.redAccent));

              final allDocs = snapshot.data!.docs;
              _performAudit(allDocs); // Arka planda taramayı yap

              final filteredDocs = allDocs.where((doc) {
                return doc['title'].toString().toLowerCase().contains(_searchQuery);
              }).toList();

              // BOŞ KASA TASARIMI
              if (filteredDocs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.3,
                          child: Icon(
                            _searchQuery.isEmpty ? Icons.lock_open_rounded : Icons.search_off_rounded,
                            size: 120, color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _searchQuery.isEmpty ? "Kasan şu an boş , Sırların bizimle güvende!" : "Aradığın sırrı bulamadık.",
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const AddPasswordSheet(),
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                            child: const Text("İLK ŞİFREYİ EKLE", style: TextStyle(color: Colors.white)),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  var doc = filteredDocs[index];
                  return Dismissible(
                    key: Key(doc.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.redAccent.withOpacity(0.7),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('passwords').doc(doc.id).delete();
                    },
                    child: Card(
                      color: Theme.of(context).cardColor,
                      child: ListTile(
                        leading: getIconForTitle(doc['title']),
                        title: Text(doc['title']),
                        subtitle: const Text("••••••••", style: TextStyle(color: Colors.grey)),
                        onTap: () async {
                          if (await AuthService.authenticate()) {
                            if (!context.mounted) return;
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Theme.of(context).cardColor,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(doc['title'], style: const TextStyle(fontSize: 20)),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(child: Text(doc['password'], style: const TextStyle(color: Colors.redAccent, fontSize: 22))),
                                        IconButton(icon: const Icon(Icons.copy, color: Colors.white), onPressed: () => Clipboard.setData(ClipboardData(text: doc['password']))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// İKON SEÇİCİ
Widget getIconForTitle(String title) {
  String t = title.toLowerCase();
  if (t.contains("instagram")) return const Icon(Icons.camera_alt, color: Colors.purpleAccent);
  if (t.contains("facebook")) return const Icon(Icons.facebook, color: Colors.blueAccent);
  if (t.contains("google") || t.contains("gmail")) return const Icon(Icons.g_mobiledata, color: Colors.redAccent, size: 30);
  if (t.contains("bank") || t.contains("hesap")) return const Icon(Icons.account_balance, color: Colors.amber);
  return const Icon(Icons.vpn_key, color: Colors.redAccent);
}
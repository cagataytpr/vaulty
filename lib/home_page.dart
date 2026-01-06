import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart'; 
import 'password_generator_page.dart';
import 'add_password_sheet.dart';
import 'auth_service.dart';
import 'encryption_service.dart';
import 'login_screen.dart';

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
        extendBody: true, 
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        
        // --- SAYFA GEÇİŞ ANİMASYONU ---
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0), // Hafif sağdan kayma
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _pages[_currentIndex],
        ),
        
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.indicator,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.all(15),
          snakeViewColor: Colors.grey,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blueGrey.withValues(alpha: 0.5),
          backgroundColor: Colors.black.withValues(alpha: 0.3), 
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.lock_rounded), label: 'Kasa'),
            BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'Üretici'),
            BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: 'Ayarlar'),
          ],
        ),

        floatingActionButton: _currentIndex == 0
            ? Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  elevation: 0,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).cardColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      builder: (context) => const AddPasswordSheet(),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
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
  bool _forceReload = false;

  @override
  void initState() {
    super.initState();
    _checkDailyReportStatus();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _forceReload = true);
    });
  }

  Future<void> _checkDailyReportStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String? lastCheck = prefs.getString('last_security_check');

    if (lastCheck != today) {
      setState(() => _showReport = true);
      await prefs.setString('last_security_check', today);
    }
  }

  void _performAudit(List<QueryDocumentSnapshot> docs) {
    int weak = 0;
    Map<String, int> counts = {};
    for (var doc in docs) {
      try {
        String rawPass = EncryptionService.decrypt(doc['password'], FirebaseAuth.instance.currentUser!.uid);
        if (rawPass.length < 8) weak++;
        counts[rawPass] = (counts[rawPass] ?? 0) + 1;
      } catch (e) {
        continue;
      }
    }
    int reused = counts.values.where((c) => c > 1).length;
    
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
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 60, 15, 10),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Sırlarında ara...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.redAccent),
                filled: true,
                fillColor: Theme.of(context).cardColor.withValues(alpha: 0.8),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),
            ),
          ),
        ),

        if (_showReport && _riskCount > 0 && _searchQuery.isEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent.withValues(alpha: 0.2), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, color: Colors.redAccent),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Kuzen, senin için $_riskCount risk buldum.",
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: Colors.grey),
                  onPressed: () => setState(() => _showReport = false),
                )
              ],
            ),
          ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('passwords')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
              }

              final allDocs = snapshot.data?.docs ?? [];
              _performAudit(allDocs);

              final filteredDocs = allDocs.where((doc) {
                return doc['title'].toString().toLowerCase().contains(_searchQuery);
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_searchQuery.isEmpty ? Icons.auto_fix_off_rounded : Icons.search_off_rounded, size: 80, color: Colors.white10),
                      const SizedBox(height: 20),
                      Text(_searchQuery.isEmpty ? "Kasa şimdilik sessiz..." : "İz bulunamadı.", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  var doc = filteredDocs[index];
                  // --- KART GİRİŞ ANİMASYONU ---
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400 + (index * 50)), // Kartlar sırayla gelir
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)), // Aşağıdan yukarı süzülme
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Dismissible(
                          key: Key(doc.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            color: Colors.redAccent.withValues(alpha: 0.6),
                            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                          ),
                          onDismissed: (_) {
                            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('passwords').doc(doc.id).delete();
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: getIconForTitle(doc['title']),
                            ),
                            title: Text(doc['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text("••••••••", style: TextStyle(color: Colors.grey, letterSpacing: 3, fontSize: 16)),
                            ),
                            trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.2)),
                            onTap: () async {
                              if (await AuthService.authenticate()) {
                                if (!context.mounted) return;
                                String uid = FirebaseAuth.instance.currentUser!.uid;
                                String decryptedPassword = EncryptionService.decrypt(doc['password'], uid);

                                if (!context.mounted) return;
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).cardColor,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
                                  builder: (context) => Container(
                                    padding: const EdgeInsets.all(35.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10))),
                                        const SizedBox(height: 25),
                                        Text(doc['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 30),
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
                                          child: Row(
                                            children: [
                                              Expanded(child: Text(decryptedPassword, style: const TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.w600))),
                                              IconButton(
                                                icon: const Icon(Icons.copy_all_rounded, color: Colors.white70), 
                                                onPressed: () {
                                                  Clipboard.setData(ClipboardData(text: decryptedPassword));
                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kopyalandı!"), behavior: SnackBarBehavior.floating));
                                                }
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
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
  Widget getIconForTitle(String title) {
  String t = title.toLowerCase();
  if (t.contains("instagram")) return const Icon(Icons.camera_alt_outlined, color: Colors.purpleAccent);
  if (t.contains("facebook")) return const Icon(Icons.facebook_outlined, color: Colors.blueAccent);
  if (t.contains("google") || t.contains("gmail")) return const Icon(Icons.alternate_email_rounded, color: Colors.redAccent);
  if (t.contains("bank") || t.contains("hesap")) return const Icon(Icons.account_balance_wallet_outlined, color: Colors.amber);
  return const Icon(Icons.key_outlined, color: Colors.redAccent);
}
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaulty/settings_page.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'package:flutter/services.dart';
import 'password_generator_page.dart';
import 'add_password_sheet.dart';

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
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,       
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Theme.of(context).cardColor,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Kasa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: 'Üretici',
            ),
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

class VaultListBody extends StatelessWidget {
  const VaultListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('passwords')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Hata!", style: TextStyle(color: Colors.white)));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("Henüz hiç şifre eklemedin.", style: TextStyle(color: Colors.grey)));

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return Dismissible(
              key: Key(doc.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                final bool confirmRes = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).cardColor,
                    title: const Text("Şifreyi Sil", style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text("Bu işlem geri alınamaz. Emin misiniz?", style: TextStyle(color: Colors.grey)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("İptal")),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sil", style: TextStyle(color: Colors.redAccent))),
                    ],
                  ),
                ) ?? false;

                if (confirmRes) {
                  return await AuthService.authenticate();
                }
                return false;
              },
              onDismissed: (_) {
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('passwords').doc(doc.id).delete();
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.redAccent.withValues(alpha: 0.7),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
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
    );
  }
}
// home_page.dart dosyasının en sonuna ekle
Widget getIconForTitle(String title) {
  String t = title.toLowerCase();
  
  if (t.contains("instagram")) return const Icon(Icons.camera_alt, color: Colors.purpleAccent);
  if (t.contains("facebook")) return const Icon(Icons.facebook, color: Colors.blueAccent);
  if (t.contains("google") || t.contains("gmail")) return const Icon(Icons.g_mobiledata, color: Colors.redAccent, size: 30);
  if (t.contains("twitter") || t.contains(" x ")) return const Icon(Icons.close, color: Colors.white); 
  if (t.contains("bank") || t.contains("hesap") || t.contains("kart")) return const Icon(Icons.account_balance, color: Colors.amber);
  if (t.contains("netflix")) return const Icon(Icons.movie, color: Colors.red);
  if (t.contains("spotify")) return const Icon(Icons.music_note, color: Colors.green);
  if (t.contains("github")) return const Icon(Icons.code, color: Colors.white);
  
  return const Icon(Icons.vpn_key, color: Colors.redAccent);
}
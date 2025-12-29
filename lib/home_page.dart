import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        appBar: AppBar(
          title: const Text("Vaulty Kasa", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('passwords')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Hata oluştu!", style: TextStyle(color: Colors.white)));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Henüz hiç şifre eklemedin.", style: TextStyle(color: Colors.grey)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];

                return Dismissible(
                  key: Key(doc.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    // 1. Görsel onay al (Emin misin?)
                    final bool confirmRes = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1A1A1A),
                        title: const Text("Şifreyi Sil", style: TextStyle(color: Colors.white)),
                        content: Text("${doc['title']} kalıcı olarak silinecek. Emin misin?", style: const TextStyle(color: Colors.grey)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Vazgeç", style: TextStyle(color: Colors.grey)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Sil", style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ) ?? false;

                    // 2. Eğer kullanıcı "Sil" dediyse, ŞİMDİ PARMAK İZİ/PIN İSTE
                    if (confirmRes) {
                      bool authenticated = await AuthService.authenticate();
                      if (authenticated) {
                        return true; // Kimlik doğrulandı, kart silinebilir
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Kimlik doğrulanamadı, silme iptal edildi."), backgroundColor: Colors.redAccent),
                          );
                        }
                        return false; 
                      }
                    }
                    return false; 
                  },
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('passwords')
                        .doc(doc.id)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${doc['title']} güvenli şekilde silindi."), backgroundColor: Colors.redAccent),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever, color: Colors.white),
                        Text("Güvenli Sil", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ),
                  child: Card(
                    color: const Color(0xFF1A1A1A),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      onTap: () async {
                        bool isAuthenticated = await AuthService.authenticate();
                        if (isAuthenticated) {
                          if (!context.mounted) return;
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF1A1A1A),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                            ),
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10))),
                                  const SizedBox(height: 25),
                                  Text(doc['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(height: 25),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            doc['password'],
                                            style: const TextStyle(fontSize: 20, color: Colors.redAccent, letterSpacing: 1.2),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy, color: Colors.white),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: doc['password']));
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Şifre panoya kopyalandı!"), backgroundColor: Colors.redAccent),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      leading: const Icon(Icons.vpn_key, color: Colors.redAccent),
                      title: Text(doc['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: const Text("••••••••", style: TextStyle(color: Colors.grey)),
                      trailing: const Icon(Icons.touch_app, size: 18, color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: const Color(0xFF1A1A1A),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const AddPasswordSheet(),
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class AddPasswordSheet extends StatefulWidget {
  const AddPasswordSheet({super.key});

  @override
  State<AddPasswordSheet> createState() => _AddPasswordSheetState();
}

class _AddPasswordSheetState extends State<AddPasswordSheet> {
  final _titleController = TextEditingController();
  final _passController = TextEditingController();

  void _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _titleController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('passwords').add({
        'title': _titleController.text,
        'password': _passController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Yeni Şifre Ekle", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: "Başlık (Örn: Gmail)", border: OutlineInputBorder(), labelStyle: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: "Şifre", border: OutlineInputBorder(), labelStyle: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveToFirebase,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
            child: const Text("Kaydet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
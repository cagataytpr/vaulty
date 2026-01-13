import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:vaulty/l10n/app_localizations.dart';
import 'package:vaulty/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaulty/data/services/export_service.dart';
import 'package:vaulty/views/auth/login_screen.dart';
import 'package:vaulty/data/services/auth_service.dart';
import 'package:vaulty/view_models/locale_view_model.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    final localeViewModel = context.watch<LocaleViewModel>();

    // Mevcut temanın aydınlık mı karanlık mı olduğunu anlık yakalıyoruz
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Tema bazlı ana renkler
    Color mainTextColor = isDark ? Colors.white : Colors.black87;
    Color subTextColor = isDark ? Colors.white54 : Colors.black54;
    Color cardBgColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);
    Color borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PROFİL KARTI ---
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                      child: const Icon(Icons.person_rounded, size: 40, color: Colors.redAccent),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.secureSession.toUpperCase(), 
                            style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          const SizedBox(height: 5),
                          Text(
                            user?.email ?? l10n.defaultUser,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainTextColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              Text(l10n.preferences.toUpperCase(), 
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
              const SizedBox(height: 15),

              // --- AYAR GRUBU ---
              _buildSettingsGroup(
                borderColor: borderColor,
                cardBgColor: cardBgColor,
                children: [
                _buildSettingsTile(
                  isDark: isDark,
                  icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  title: l10n.darkMode,
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: Colors.redAccent,
                    onChanged: (val) => VaultyApp.of(context)?.changeTheme(val ? ThemeMode.dark : ThemeMode.light),
                  ),
                ),
                _buildSettingsTile(
                  isDark: isDark,
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: localeViewModel.locale?.languageCode ?? Localizations.localeOf(context).languageCode,
                      dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white54 : Colors.black54),
                      onChanged: (String? code) {
                        if (code != null) {
                          context.read<LocaleViewModel>().setLocale(Locale(code));
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'en', 
                          child: Text("🇺🇸 English", style: TextStyle(color: mainTextColor, fontSize: 14))
                        ),
                        DropdownMenuItem(
                          value: 'tr', 
                          child: Text("🇹🇷 Türkçe", style: TextStyle(color: mainTextColor, fontSize: 14))
                        ),
                        DropdownMenuItem(
                          value: 'de', 
                          child: Text("🇩🇪 Deutsch", style: TextStyle(color: mainTextColor, fontSize: 14))
                        ),
                        DropdownMenuItem(
                          value: 'es', 
                          child: Text("🇪🇸 Español", style: TextStyle(color: mainTextColor, fontSize: 14))
                        ),
                        DropdownMenuItem(
                          value: 'fr', 
                          child: Text("🇫🇷 Français", style: TextStyle(color: mainTextColor, fontSize: 14))
                        ),
                      ],
                    ),
                  ),
                ),
                _buildSettingsTile(
                  isDark: isDark,
                  icon: Icons.picture_as_pdf_rounded,
                  title: l10n.exportPdf,
                  onTap: () async {
                    if (await AuthService.authenticateUser()) {
                      final snapshot = await FirebaseFirestore.instance
                          .collection('users').doc(user?.uid).collection('passwords').get();
                      if (snapshot.docs.isNotEmpty) {
                        await ExportService.exportPasswordsToPdf(snapshot.docs);
                      } else {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noPasswords)));
                      }
                    }
                  },
                ),
              ]),

              const SizedBox(height: 30),
              Text(l10n.system.toUpperCase(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
              const SizedBox(height: 15),

              _buildSettingsGroup(
                borderColor: borderColor,
                cardBgColor: cardBgColor,
                children: [
                _buildSettingsTile(
                  isDark: isDark,
                  icon: Icons.info_outline_rounded,
                  title: l10n.about,
                  subtitle: "${l10n.version} 1.0.0",
                ),
                _buildSettingsTile(
                  isDark: isDark,
                  icon: Icons.logout_rounded,
                  title: l10n.signOut,
                  titleColor: Colors.orangeAccent,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  },
                ),
              ]),

              const SizedBox(height: 50),
              Center(child: Text(l10n.designedBy, style: TextStyle(color: subTextColor, fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({required List<Widget> children, required Color cardBgColor, required Color borderColor}) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required bool isDark,
    required IconData icon, 
    required String title, 
    String? subtitle, 
    Widget? trailing, 
    VoidCallback? onTap, 
    Color? titleColor
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: titleColor ?? Colors.redAccent),
      title: Text(title, style: TextStyle(
        color: titleColor ?? (isDark ? Colors.white : Colors.black87), 
        fontWeight: FontWeight.w500
      )),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
      trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.black26) : null),
    );
  }
}

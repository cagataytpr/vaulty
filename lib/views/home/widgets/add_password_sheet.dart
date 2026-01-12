import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/home_view_model.dart';
import 'package:vaulty/l10n/app_localizations.dart';

class AddPasswordSheet extends StatefulWidget {
  const AddPasswordSheet({super.key});

  @override
  State<AddPasswordSheet> createState() => _AddPasswordSheetState();
}

class _AddPasswordSheetState extends State<AddPasswordSheet> {
  final _titleController = TextEditingController();
  final _passController = TextEditingController();

  Map<String, dynamic> _checkStrength(String password, AppLocalizations l10n) {
    if (password.isEmpty) return {"label": "", "color": Colors.transparent, "percent": 0.0};
    
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    if (strength <= 0.25) return {"label": l10n.veryWeak.toUpperCase(), "color": Colors.redAccent, "percent": 0.25};
    if (strength <= 0.50) return {"label": l10n.weak.toUpperCase(), "color": Colors.orangeAccent, "percent": 0.50};
    if (strength <= 0.75) return {"label": l10n.secure.toUpperCase(), "color": Colors.blueAccent, "percent": 0.75};
    return {"label": l10n.cryptoLevel.toUpperCase(), "color": Colors.greenAccent, "percent": 1.0};
  }

  void _save(BuildContext context) async {
    if (_titleController.text.isNotEmpty) {
      // Use Provider to add password
      await context.read<HomeViewModel>().addNewPassword(
        _titleController.text, 
        _passController.text
      );
      
      
      if (!mounted) return;
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var strength = _checkStrength(_passController.text, l10n);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        // Klavyenin üstünde kalmasını sağlar
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView( // 🚀 ÇÖZÜM: İçeriği kaydırılabilir yaptık
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Sadece içeriği kadar yer kaplar
            children: [
              // Handle Bar
              Container(
                width: 50, height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.black12,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              const SizedBox(height: 25),
              
              Text(
                l10n.newDataAccess.toUpperCase(),
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 2,
                  color: isDark ? Colors.white : Colors.black87
                ),
              ),
              const SizedBox(height: 20),

              _buildTerminalInput(
                controller: _titleController,
                label: l10n.websiteName.toUpperCase(),
                icon: Icons.label_important_outline_rounded,
                isDark: isDark,
              ),
              
              const SizedBox(height: 15),

              _buildTerminalInput(
                controller: _passController,
                label: l10n.secretPassword.toUpperCase(),
                icon: Icons.vpn_key_outlined,
                isDark: isDark,
                isPassword: true,
                onChanged: (v) => setState(() {}),
              ),
              
              // Güvenlik barı açıldığında artık ekranı aşağı kaydırabileceğiz
              if (_passController.text.isNotEmpty) ...[
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.securityProtocol.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(strength["label"], style: TextStyle(color: strength["color"], fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: strength["percent"],
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(strength["color"]),
                    minHeight: 6,
                  ),
                ),
              ],

              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _save(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, 
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: Text(l10n.lockToVault.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Özel Terminal Tipi Input Widget
  Widget _buildTerminalInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        onChanged: onChanged,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
          prefixIcon: Icon(icon, color: Colors.redAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

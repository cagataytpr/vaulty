import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vaulty/data/services/auth_service.dart';
import 'package:vaulty/data/models/password_model.dart';
import 'package:vaulty/view_models/home_view_model.dart';

class PasswordCard extends StatefulWidget {
  final PasswordModel password;
  final Animation<double>? animation;

  const PasswordCard({
    super.key,
    required this.password,
    this.animation,
  });

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  Timer? _clipboardTimer;

  @override
  void dispose() {
    _clipboardTimer?.cancel();
    super.dispose();
  }

  // --- UI Helpers ---
  Widget getIconForTitle(String title) {
    String t = title.toLowerCase();
    IconData iconData;
    Color iconColor = Colors.redAccent;

    if (t.contains("instagram")) {
      iconData = Icons.camera_alt_outlined;
    } else if (t.contains("facebook")) {
      iconData = Icons.facebook_rounded;
    } else if (t.contains("google") || t.contains("gmail")) {
      iconData = Icons.alternate_email_rounded;
    } else if (t.contains("twitter") || t.contains(" x ")) {
      iconData = Icons.close_rounded;
    } else if (t.contains("bank") || t.contains("hesap") || t.contains("kart") || t.contains("ziraat") || t.contains("garanti")) {
      iconData = Icons.credit_card_rounded;
    } else if (t.contains("crypto") || t.contains("binance") || t.contains("btc") || t.contains("eth")) {
      iconData = Icons.currency_bitcoin_rounded;
    } else if (t.contains("discord")) {
      iconData = Icons.discord_rounded;
    } else if (t.contains("netflix")) {
      iconData = Icons.movie_filter_rounded;
    } else if (t.contains("spotify")) {
      iconData = Icons.library_music_rounded;
    } else if (t.contains("apple") || t.contains("icloud")) {
      iconData = Icons.apple_rounded;
    } else if (t.contains("microsoft") || t.contains("outlook") || t.contains("hotmail")) {
      iconData = Icons.grid_view_rounded;
    } else {
      iconData = Icons.shield_moon_rounded;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [iconColor.withValues(alpha: 0.15), iconColor.withValues(alpha: 0.0)],
        ),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 26,
        shadows: [
          Shadow(blurRadius: 10, color: iconColor.withValues(alpha: 0.6), offset: const Offset(0, 0)),
        ],
      ),
    );
  }

  void _showPasswordDetails(BuildContext context) async {
    if (await AuthService.authenticate()) {
      if (!context.mounted) return;
      
      final viewModel = context.read<HomeViewModel>();
      String decryptedPassword;
      try {
        decryptedPassword = await viewModel.decryptPassword(widget.password.encryptedPassword);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Error: Decryption failed. Old format?"), backgroundColor: Colors.red),
        );
        return;
      }

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
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 25),
              Text(widget.password.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white10)),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                          decryptedPassword,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.redAccent, 
                            fontSize: 24, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_all_rounded, color: Colors.white70),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: decryptedPassword));
                        
                        _clipboardTimer?.cancel();
                        _clipboardTimer = Timer(const Duration(seconds: 45), () {
                          Clipboard.setData(const ClipboardData(text: ""));
                        });

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).clearSnackBars(); // Temiz bir sunum için
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Şifre kopyalandı! Güvenliğiniz için 45 saniye sonra panodan silinecektir."),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 4),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If animation is provided, wrap in Fade/Transition. Otherwise just return container.
    // However, Parent usually handles the animation builder.
    // For specific animation passed from list:
    
    Widget content = Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Dismissible(
          key: Key(widget.password.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            color: Colors.redAccent.withValues(alpha: 0.6),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
          ),
          confirmDismiss: (direction) async {
            // 1. CONFIRMATION DIALOG
            final bool? shouldDelete = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF1E1E1E),
                title: const Text("Şifreyi Sil?", style: TextStyle(color: Colors.white)),
                content: const Text(
                  "Bu işlem geri alınamaz. Bu şifreyi kalıcı olarak silmek istediğine emin misin?",
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text("İptal", style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text("SİL", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );

            if (shouldDelete != true) return false;

            // 2. AUTHENTICATION
            // Dialog kapandıktan sonra biyometrik doğrulama
            final bool authenticated = await AuthService.authenticateUser();

            // 3. EXECUTION DECISION
            // Eğer doğrulama başarılıysa true döndür (onDismissed çalışır)
            // Başarısızsa false döndür (işlem iptal)
            return authenticated;
          },
          onDismissed: (_) {
             context.read<HomeViewModel>().deletePassword(widget.password.id);
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: getIconForTitle(widget.password.title),
            title: Text(widget.password.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text("••••••••", style: TextStyle(color: Colors.grey, letterSpacing: 3, fontSize: 16)),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.2)),
            onTap: () => _showPasswordDetails(context),
          ),
        ),
      ),
    );

    if (widget.animation != null) {
      return FadeTransition(
        opacity: widget.animation!,
         child: SlideTransition(
          position: widget.animation!.drive(
             Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
             .chain(CurveTween(curve: Curves.easeOutCubic))
          ),
          child: content
         ),
      );
    }

    return content;
  }
}

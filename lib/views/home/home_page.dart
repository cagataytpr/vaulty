import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:vaulty/view_models/home_view_model.dart';
import 'package:vaulty/views/home/widgets/password_card.dart';
import 'package:vaulty/l10n/app_localizations.dart';

import 'package:vaulty/views/home/widgets/add_password_sheet.dart';
import 'package:vaulty/views/password_generator_page.dart';
import 'package:vaulty/views/settings_page.dart';

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

        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(15),
          snakeViewColor: Colors.grey,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blueGrey.withValues(alpha: 0.5),
          backgroundColor: Colors.black.withValues(alpha: 0.3),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_rounded),
              label: 'Kasa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_rounded),
              label: 'Üretici',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune_rounded),
              label: 'Ayarlar',
            ),
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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
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
  bool _showReport = false;
  
  // Arama metnini ViewModel ile senkronize tutmak için controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkDailyReportStatus();
  }
  
  /// Günlük güvenlik raporu durumunu kontrol eder.
  Future<void> _checkDailyReportStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String? lastCheck = prefs.getString('last_security_check');

    if (lastCheck != today) {
      if (mounted) setState(() => _showReport = true);
      await prefs.setString('last_security_check', today);
    }
  }

  void _showRiskAnalysis(BuildContext context, HomeViewModel viewModel) {
    // ViewModel üzerinden güvenlik raporunu al
    final risks = viewModel.getSecurityReport(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.securityReportTitle, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 20),
            risks.isEmpty
                ? Text(AppLocalizations.of(context)!.securityNoRisks, style: const TextStyle(color: Colors.white70))
                : Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: risks.length,
                      itemBuilder: (context, i) => ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
                        title: Text(risks[i]['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(risks[i]['reason']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        final l10n = AppLocalizations.of(context)!;
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
                  controller: _searchController,
                  onChanged: (value) => viewModel.setSearchQuery(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.searchPlaceholder,
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

            // --- RİSK BANDI ---
            // Günlük kontrol yapıldıysa, risk varsa ve arama yapılmıyorsa göster
            if (_showReport && viewModel.riskCount > 0 && viewModel.searchQuery.isEmpty)
              GestureDetector(
                onTap: () => _showRiskAnalysis(context, viewModel),
                child: AnimatedContainer(
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
                          AppLocalizations.of(context)!.securityRiskFound(viewModel.riskCount),
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
                    ],
                  ),
                ),
              ),

            Expanded(
              child: _buildList(viewModel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(HomeViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
    }

    if (viewModel.passwords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              viewModel.searchQuery.isEmpty ? Icons.auto_fix_off_rounded : Icons.search_off_rounded,
              size: 80,
              color: Colors.white10,
            ),
            const SizedBox(height: 20),
            Text(
              viewModel.searchQuery.isEmpty ? l10n.emptyVault : "İz bulunamadı.",
              style: const TextStyle(color: Colors.grey),
            ),
            if (viewModel.searchQuery.isEmpty)
               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: Text(l10n.emptyVaultSub, style: const TextStyle(color: Colors.white30, fontSize: 12)),
               ),
          ],
        ),
      );
    }

    // Responsive düzen: Dar ekranlarda liste, geniş ekranlarda ızgara görünümü
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        if (isDesktop) {
          // Masaüstü: Genişliğe göre 2 veya 3 sütunlu ızgara
          final crossAxisCount = constraints.maxWidth >= 1200 ? 3 : 2;

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: viewModel.passwords.length,
            itemBuilder: (context, index) {
              var passwordData = viewModel.passwords[index];
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 400 + (index * 50)),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
                ),
                child: PasswordCard(password: passwordData),
              );
            },
          );
        }

        // Mobil: Mevcut dikey liste görünümü
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
          itemCount: viewModel.passwords.length,
          itemBuilder: (context, index) {
            var passwordData = viewModel.passwords[index];
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 400 + (index * 50)),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
              ),
              child: PasswordCard(password: passwordData),
            );
          },
        );
      },
    );
  }
}

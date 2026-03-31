import 'package:flutter/material.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/header.dart';
import 'package:shopito_app/presentation/widgets/orders_section.dart';
import 'package:shopito_app/presentation/widgets/user_info_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C8D2F),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Header(title: "Profil"),

            // Profile content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: const Color(0xFFF5F5F5),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserInfoSection(),
                      const SizedBox(height: 20),

                      // Orders section
                      OrdersSection(),

                      const SizedBox(height: 20),

                      // Settings options
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Postavke",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF121212),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildSettingItem(
                              Icons.logout,
                              "Odjavi se",
                              "Sigurno izlaženje iz aplikacije",
                              () => _showLogoutDialog(),
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isDestructive
                        ? Colors.red.withValues(alpha: 0.1)
                        : Color(0xFF3C8D2F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? Colors.red : Color(0xFF3C8D2F),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDestructive ? Colors.red : Color(0xFF121212),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Odjavi se"),
          content: Text("Da li ste sigurni da se želite odjaviti?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Otkaži"),
            ),
            ElevatedButton(
              onPressed: () {
                getIt<AuthBloc>().add(AuthLogout());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Odjavi se", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

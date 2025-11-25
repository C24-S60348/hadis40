import 'package:flutter/material.dart';
import 'dart:io';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Big Logo
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              
              Divider(color: Colors.black54),
              
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.mosque,
                      title: 'Panduan Solat Sunat',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/panduan-solat-sunat');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.format_quote,
                      title: 'Kata-kata Hikmah',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/kata-kata-hikmah');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.calculate,
                      title: 'Surah Calculator',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/surah-calculator');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.location_city,
                      title: 'Senarai Surau Jumaat',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/senarai-surau-jumaat');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/settings');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.favorite,
                      title: 'Favourite',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/bookmarks');
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.share,
                      title: 'Share',
                      onTap: () {
                        Navigator.of(context).pop();
                        _shareApp(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.help,
                      title: 'Help (Update Log)',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/info');
                      },
                    ),
                    Divider(color: Colors.black54),
                    _buildMenuItem(
                      context,
                      icon: Icons.exit_to_app,
                      title: 'Exit app',
                      onTap: () {
                        Navigator.of(context).pop();
                        _exitApp(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _shareApp(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality - to be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar Aplikasi'),
          content: Text('Adakah anda pasti ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}


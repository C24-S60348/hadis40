import 'package:flutter/material.dart';
import 'navigation_service.dart';

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
                        NavigationService.closeDrawer(context);
                        NavigationService.goToHome(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.book,
                      title: 'Tentang Hadis 40',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToAboutHadis40(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.mosque,
                      title: 'Panduan Solat Sunat',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToPanduanSolatSunat(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.format_quote,
                      title: 'Kata-kata Hikmah',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToKataKataHikmah(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.calculate,
                      title: 'Surah Calculator',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToSurahCalculator(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.location_city,
                      title: 'Senarai Surau Jumaat',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToSenaraiSurauJumaat(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToSettings(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.favorite,
                      title: 'Favourite',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToBookmarks(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.share,
                      title: 'Share',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.showShareDialog(context);
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.help,
                      title: 'Informasi',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.goToInfo(context);
                      },
                    ),
                    Divider(color: Colors.black54),
                    _buildMenuItem(
                      context,
                      icon: Icons.exit_to_app,
                      title: 'Exit app',
                      onTap: () {
                        NavigationService.closeDrawer(context);
                        NavigationService.showExitDialog(context);
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
}


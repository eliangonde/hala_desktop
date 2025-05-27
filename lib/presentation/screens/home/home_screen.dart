import 'package:flutter/material.dart';
import 'package:hala_desktop/presentation/screens/home/profile_screen.dart';
import 'package:hala_desktop/presentation/widgets/app_bar.dart';
import 'package:hala_desktop/presentation/widgets/navigation_rail_custom.dart';
import 'package:hala_desktop/presentation/widgets/placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Dashboard"),
      body: NavigationRailCustom(
        icons: [
          Icons.dashboard,
          Icons.timelapse,
          Icons.notifications,
          Icons.person,
        ],
        labels: ["Dashboard", "Projects", "Notifications", "Profile"],
        screens: [
          PlaceholderScreen(screenDescription: "Dashboard"),
          PlaceholderScreen(screenDescription: "Projects"),
          PlaceholderScreen(screenDescription: "Notifications"),
          ProfileScreen(),
        ],
        initialIndex: 0,
        displayMode: NavigationDisplayMode.iconsAndLabels,
        enableLogout: true, // 👈 Enables the logout button in footer
      ),
    );
  }
}

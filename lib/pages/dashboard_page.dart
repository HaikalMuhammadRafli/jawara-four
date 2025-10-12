import 'package:flutter/material.dart';
import '../widgets/dashboard/dashboard_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF3B82F6),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : isTablet ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            WelcomeSection(),
            const SizedBox(height: 32),
            
            // Summary Cards Section
            SummaryCardsSection(
              isTablet: isTablet,
              isDesktop: isDesktop,
            ),
            const SizedBox(height: 32),
            
            // Charts and Visualizations Section
            ChartsSection(
              isTablet: isTablet,
              isDesktop: isDesktop,
            ),
            const SizedBox(height: 32),
            
            // Recent Activities Section
            RecentActivitiesSection(
              isTablet: isTablet,
              isDesktop: isDesktop,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home1.dart'; // Import home1 for additional screens

class ReciteRightScreen extends StatefulWidget {
  const ReciteRightScreen({super.key});

  @override
  State<ReciteRightScreen> createState() => _ReciteRightScreenState();
}

class _ReciteRightScreenState extends State<ReciteRightScreen> {
  int _currentIndex = 0;

  // Get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ReciteRight",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E4976),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: Color(0xFF1E4976),
                                  size: 28,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showUserMenu();
                                },
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFF1E4976),
                                  child: Icon(Icons.person,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Greeting card
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E4976),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "السلام عليكم",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentUser?.displayName ?? "Tajweed Learner",
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Continue your Tajweed journey today",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE8F5E9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick action buttons
                      const Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4976),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          QuickActionCard(
                            title: "Learn Tajweed",
                            icon: Icons.book,
                            color: const Color(0xFF2E5F8F),
                            onTap: () {
                              setState(() => _currentIndex = 1);
                              _navigateToLessons();
                            },
                          ),
                          QuickActionCard(
                            title: "Practice",
                            icon: Icons.mic,
                            color: const Color(0xFF4CAF50),
                            onTap: () {
                              setState(() => _currentIndex = 2);
                              _navigateToPractice();
                            },
                          ),
                          QuickActionCard(
                            title: "Your Progress",
                            icon: Icons.trending_up,
                            color: const Color(0xFF7CB342),
                            onTap: () {
                              setState(() => _currentIndex = 3);
                              _navigateToProgress();
                            },
                          ),
                          QuickActionCard(
                            title: "Profile",
                            icon: Icons.person,
                            color: const Color(0xFFA1887F),
                            onTap: () {
                              setState(() => _currentIndex = 4);
                              _navigateToProfile();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Recent activity
                      const Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4976),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ActivityCard(
                        title: "Completed: Al-Ikhfa",
                        subtitle: "Mastered the Ikhfa rule",
                        icon: Icons.check_circle,
                        date: "Today",
                      ),
                      ActivityCard(
                        title: "Practiced: Al-Madd",
                        subtitle: "Recited 5 verses",
                        icon: Icons.play_circle,
                        date: "Yesterday",
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToLessons() {
    // TODO: Navigate to lessons screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lessons feature - Coming soon")),
    );
  }

  void _navigateToPractice() {
    // TODO: Navigate to practice screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Practice feature - Coming soon")),
    );
  }

  void _navigateToProgress() {
    // TODO: Navigate to progress screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Progress feature - Coming soon")),
    );
  }

  void _navigateToProfile() {
    // TODO: Navigate to profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile feature - Coming soon")),
    );
  }

  void _showUserMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentUser?.email ?? "User",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToProfile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String date;

  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E4976), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}


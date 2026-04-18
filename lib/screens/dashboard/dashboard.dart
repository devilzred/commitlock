import 'package:commitlock/components/activesessioncard.dart';
import 'package:commitlock/components/streakmenu.dart';
import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/core/utils/fakedata.dart';
import 'package:commitlock/providers/auth_provider.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:commitlock/providers/streak_provider.dart';
import 'package:commitlock/screens/session/new_commitment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final session = Provider.of<SessionProvider>(context, listen: false);
    final streak = Provider.of<StreakProvider>(context, listen: false);

    session.loadSessions(auth.currentUser!.id);
    streak.loadStreak(auth.currentUser!.id, session);

    // Keep streak in sync when sessions change
    // session.setOnSessionChanged(() {
    //   streak.onSessionChanged(session);
    // });
  });
}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final sessionData = context.watch<SessionProvider>();
    final streakData = context.watch<StreakProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) async {
              final auth = context.read<AuthProvider>();
              final session = context.read<SessionProvider>();
              final streak = context.read<StreakProvider>();

              if (val == 'seed') {
                await FakeDataSeeder.seed();
              } else {
                await FakeDataSeeder.clear();
              }

              session.loadSessions(auth.currentUser!.id);
              streak.loadStreak(auth.currentUser!.id, session);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'seed', child: Text('Seed fake data')),
              const PopupMenuItem(value: 'clear', child: Text('Clear data')),
            ],
            icon: const Icon(Icons.bug_report_outlined),
          ),
        ],
      ),
      body: Consumer<SessionProvider>(
        builder: (context, data, child) {
          final activeSessions = data.activeSessions;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Fueled by caffeine ☕ • ✨ crafted by Karthik',
                    style: Textfont.subText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 160,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.accentColor,
                          // border: Border.all(color: AppColors.secondaryColor, width: 2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            streakData.streakCount > 2
                                ? Text('🔥', style: Textfont.large)
                                : Text('💔', style: Textfont.large),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Streak', style: Textfont.heading2),
                                Text(
                                  '${streakData.streakCount} days',
                                  style: Textfont.heading2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome back!', style: Textfont.heading2),
                          Text('${user?.name}', style: Textfont.heading),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  WeeklyStreak(weekData: streakData.weekData),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Completed ", style: Textfont.heading2),
                      Text(
                        "${sessionData.todayCompletedMinutes}min ",
                        style: Textfont.heading2.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text("of ", style: Textfont.heading2),
                      Text(
                        "${sessionData.todayPlannedMinutes}min ",
                        style: Textfont.heading2.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text("Today", style: Textfont.heading2),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text('Active Session', style: Textfont.heading2),
                  const SizedBox(height: 20),

                  activeSessions.isEmpty
                      ? Center(
                          child: Text(
                            'No active session ☹️',
                            style: Textfont.heading.copyWith(
                              color: AppColors.subTextColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeSessions.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ActiveSessionCard(
                              session: activeSessions[index],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 100.0, left: 30),
        child: FloatingActionButton.extended(
          isExtended: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NewCommitmentScreen()),
            );
          },
          backgroundColor: AppColors.primaryColor,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: AppColors.backgroundColor),
              const SizedBox(width: 8),
              const Text('New Commitment', style: Textfont.button2),
            ],
          ),
        ),
      ),
    );
  }
}

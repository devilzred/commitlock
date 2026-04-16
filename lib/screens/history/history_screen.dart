import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/models/session_model.dart';
import 'package:commitlock/providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Call data.init() once, outside the build method
    Provider.of<HistoryProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session History', style: Textfont.appBar),
        backgroundColor: AppColors.accentColor,
        elevation: 0,
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, data, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow(data),
              _buildFilterRow(data),
              Expanded(child: _buildSessionList(data)),
            ],
          );
        },
      ),
    );
  }
  // Summary Row
  Widget _buildSummaryRow(HistoryProvider historyProvider) {
    int totalSessions = historyProvider.sessions.length;
    int completedSessions = historyProvider.sessions
        .where((s) => s.isCompleted)
        .length;
    double successRate = totalSessions > 0
        ? (completedSessions / totalSessions) * 100
        : 0;
    int totalTime = historyProvider.sessions.fold(
      0,
      (sum, s) => sum + s.plannedDurationMinutes,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('Total Sessions', totalSessions.toString()),
          _buildSummaryItem(
            'Success Rate',
            '${successRate.toStringAsFixed(1)}%',
          ),
          _buildSummaryItem('Total Time', '$totalTime min'),
        ],
      ),
    );
  }
    // Helper for summary items
  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: Textfont.subText),
        SizedBox(height: 4),
        Text(value, style: Textfont.heading2),
      ],
    );
  }

  // Filter Row (Completed, Broken, All)
  Widget _buildFilterRow(HistoryProvider historyProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterOption(
            label: 'All',
            onTap: () {
              // Update filter to "All"
              historyProvider.loadSessions(); // Reset to "All"
            },
          ),
          _buildFilterOption(
            label: 'Completed',
            onTap: () {
              // Update filter to "Completed"
              historyProvider.filterSessions(isCompleted: true);
            },
          ),
          _buildFilterOption(
            label: 'Broken',
            onTap: () {
              // Update filter to "Broken"
              historyProvider.filterSessions(isCompleted: false);
            },
          ),
        ],
      ),
    );
  }

  // Filter Option Item (All, Completed, Broken)
  Widget _buildFilterOption({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(child: Text(label, style: Textfont.button)),
      ),
    );
  }

  // Session List
  Widget _buildSessionList(HistoryProvider historyProvider) {
    if (historyProvider.sessions.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: historyProvider.sessions.length,
      itemBuilder: (context, index) {
        final session = historyProvider.sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  // Empty State (No sessions)
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No sessions yet. Start your first session!',
        style: Textfont.body,
      ),
    );
  }

  // Session Card (Container Style)
  Widget _buildSessionCard(SessionModel session) {
    String formattedDate = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(session.createdAt!));
    String outcome = session.isCompleted ? 'Completed' : 'Broken';
    double penalty = session.penaltyAmount;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: AppColors.accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Info
            Text(formattedDate, style: Textfont.body),
            SizedBox(height: 8),
            Text(session.habitCategory, style: Textfont.heading2),
            SizedBox(height: 4),
            _buildSessionDetails(session),
            SizedBox(height: 8),
            // Outcome & Penalty
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(outcome, style: TextStyle(color: Colors.white)),
                  backgroundColor: outcome == 'Completed'
                      ? Colors.green
                      : Colors.red,
                ),
                Text(
                  'Penalty: \$${penalty.toStringAsFixed(2)}',
                  style: Textfont.body,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Session Details (Planned vs Actual)
  Widget _buildSessionDetails(SessionModel session) {
    int plannedDuration = session.plannedDurationMinutes;
    int actualDuration = (session.actualDurationSeconds / 60).floor();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Planned: $plannedDuration min', style: Textfont.subText),
        Text('Actual: $actualDuration min', style: Textfont.subText),
      ],
    );
  }
}
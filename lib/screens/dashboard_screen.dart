import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/homework_provider.dart';
import '../providers/study_provider.dart';
import 'add_homework_screen.dart';
import 'spaced_repetition_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int _dailyGoalMinutes = 120;

  @override
  Widget build(BuildContext context) {
    final hwProvider = context.watch<HomeworkProvider>();
    final studyProvider = context.watch<StudyProvider>();
    final studyMinutes = studyProvider.todayStudyMinutes;
    final progress = (studyMinutes / _dailyGoalMinutes).clamp(0.0, 1.0);
    final dueItems = studyProvider.dueItems;
    final pendingHw = hwProvider.pendingItems;
    final now = DateTime.now();
    final weekdays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final dayName = weekdays[now.weekday - 1];
    final months = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await hwProvider.loadAll();
            await studyProvider.loadAll();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$dayName, ${now.day} ${months[now.month]}',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Bugün 📚',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${studyProvider.todaySessions.where((s) => s.completed).length}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Daily goal card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF1E88E5)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Günlük Hedef',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            '$studyMinutes / $_dailyGoalMinutes dk',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${studyProvider.dueItems.length} tekrar bekliyor',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                          const Spacer(),
                          Text(
                            '${(progress * 100).toInt()}% tamamlandı',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.assignment_turned_in,
                        color: AppColors.success,
                        value: '${pendingHw.length}',
                        label: 'Bekleyen Ödev',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.psychology,
                        color: Colors.purple,
                        value: '${dueItems.length}',
                        label: 'Bugün Tekrar',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.timer,
                        color: AppColors.warning,
                        value: '$studyMinutes',
                        label: 'Çalışma dk',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Due reviews
                if (dueItems.isNotEmpty) ...
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🧠 Bugün Tekrar Edilecekler',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const SpacedRepetitionScreen()),
                          ),
                          child: const Text('Tümü'),
                        ),
                      ],
                    ),
                    ...dueItems.take(3).map((item) => _ReviewCard(item: item)),
                    const SizedBox(height: 16),
                  ],

                // Pending homework
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📋 Bekleyen Ödevler',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                    TextButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const AddHomeworkScreen(),
                      ).then((_) => hwProvider.loadAll()),
                      child: const Text('+ Ekle'),
                    ),
                  ],
                ),
                if (pendingHw.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('Bekleyen ödev yok! 🎉',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  ...pendingHw.take(5).map((hw) => _HomeworkCard(
                        hw: hw,
                        onComplete: () =>
                            hwProvider.updateStatus(hw.id!, HomeworkStatus.completed),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard(
      {required this.icon,
      required this.color,
      required this.value,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final SpacedRepetitionItem item;
  const _ReviewCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.purple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.topicName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text(item.subject,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Tekrar',
                style: TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  final HomeworkItem hw;
  final VoidCallback onComplete;

  const _HomeworkCard({required this.hw, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final isOverdue = hw.dueDate.isBefore(DateTime.now());
    final priorityColors = [
      Colors.grey,
      Colors.orange,
      Colors.red,
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isOverdue
                ? AppColors.error.withOpacity(0.3)
                : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: priorityColors[hw.priority.index],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hw.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '${hw.subject} • ${hw.dueDate.day}/${hw.dueDate.month}/${hw.dueDate.year}',
                  style: TextStyle(
                      fontSize: 12,
                      color: isOverdue
                          ? AppColors.error
                          : AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Checkbox(
            value: false,
            onChanged: (_) => onComplete(),
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}

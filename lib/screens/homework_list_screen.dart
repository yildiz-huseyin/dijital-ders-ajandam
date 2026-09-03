import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/homework_provider.dart';
import 'add_homework_screen.dart';

class HomeworkListScreen extends StatefulWidget {
  const HomeworkListScreen({super.key});

  @override
  State<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends State<HomeworkListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeworkProvider>();
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(
          'Ödev ve Görev Takibi',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Bekleyen (${provider.pendingItems.length})'),
            Tab(text: 'Devam (${provider.inProgressItems.length})'),
            Tab(text: 'Tamam (${provider.completedItems.length})'),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _HomeworkTab(
                    items: provider.pendingItems, provider: provider),
                _HomeworkTab(
                    items: provider.inProgressItems, provider: provider),
                _HomeworkTab(
                    items: provider.completedItems, provider: provider),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const AddHomeworkScreen(),
        ).then((_) => provider.loadAll()),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Ödev'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _HomeworkTab extends StatelessWidget {
  final List<HomeworkItem> items;
  final HomeworkProvider provider;

  const _HomeworkTab({required this.items, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Bu kategoride ödev yok 🎉',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: provider.loadAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final hw = items[i];
          return _HomeworkCard(hw: hw, provider: provider);
        },
      ),
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  final HomeworkItem hw;
  final HomeworkProvider provider;

  const _HomeworkCard({required this.hw, required this.provider});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  Color _priorityColor() {
    switch (hw.priority) {
      case HomeworkPriority.high:
        return Colors.red;
      case HomeworkPriority.medium:
        return Colors.orange;
      case HomeworkPriority.low:
        return Colors.green;
    }
  }

  String _priorityLabel() {
    switch (hw.priority) {
      case HomeworkPriority.high:
        return 'Yüksek';
      case HomeworkPriority.medium:
        return 'Orta';
      case HomeworkPriority.low:
        return 'Düşük';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = hw.dueDate.isBefore(DateTime.now()) &&
        hw.status != HomeworkStatus.completed;
    return Dismissible(
      key: Key('hw_${hw.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => provider.deleteHomework(hw.id!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isOverdue ? Colors.red.shade200 : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    hw.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: hw.status == HomeworkStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _priorityColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _priorityLabel(),
                    style: TextStyle(
                        color: _priorityColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              hw.subject,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
            if (hw.description != null && hw.description!.isNotEmpty) ...
              [
                const SizedBox(height: 4),
                Text(
                  hw.description!,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 13,
                  color: isOverdue ? Colors.red : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(hw.dueDate),
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          isOverdue ? Colors.red : AppColors.textSecondary),
                ),
                const Spacer(),
                if (hw.status != HomeworkStatus.completed)
                  Row(
                    children: [
                      if (hw.status != HomeworkStatus.inProgress)
                        TextButton(
                          onPressed: () => provider.updateStatus(
                              hw.id!, HomeworkStatus.inProgress),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0)),
                          child: const Text('Başla',
                              style: TextStyle(fontSize: 12)),
                        ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () => provider.updateStatus(
                            hw.id!, HomeworkStatus.completed),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 0),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('Tamamla'),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'add_homework_screen.dart';

class HomeworkListScreen extends StatefulWidget {
  const HomeworkListScreen({super.key});

  @override
  State<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends State<HomeworkListScreen> {
  final List<HomeworkItem> _allHomeworks = [
    HomeworkItem(
      id: '1',
      title: 'Laboratuvar Raporu: Asit-Baz Titrasyonu',
      subject: 'Kimya',
      deadline: 'Yarın 17:00 (Son 22 Saat)',
      detail: 'Grafikler ve hata analizi bölümü eksik. Rapor formatına uygun çıktısı alınacak.',
      progress: 70,
      priority: 'urgent',
    ),
    HomeworkItem(
      id: '2',
      title: '50 Soru: Çemberde Açılar ve Teğetler',
      subject: 'Geometri',
      deadline: 'Cuma 23:59 (3 Gün Kaldı)',
      detail: '20 / 50 soru tamamlandı. Karekök yayınları test 4-5.',
      progress: 40,
      priority: 'normal',
    ),
    HomeworkItem(
      id: '3',
      title: 'Cumhuriyet Dönemi Şiir Özeti',
      subject: 'Edebiyat',
      deadline: 'Pazartesi 09:00',
      detail: 'Yedi Meşaleciler ve Garip Akımı karşılaştırma tablosu.',
      progress: 10,
      priority: 'normal',
    ),
    HomeworkItem(
      id: '4',
      title: 'Mekanik Enerji Çıkmış Sorular Fasikülü',
      subject: 'Fizik',
      deadline: '10 Gün Kaldı',
      detail: 'ÖSYM son 10 yıl sınav soruları çözümü.',
      progress: 0,
      priority: 'normal',
    ),
  ];

  String _filter = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'Tümü'
        ? _allHomeworks
        : _filter == 'Tamamlananlar'
            ? _allHomeworks.where((h) => h.isCompleted).toList()
            : _allHomeworks.where((h) => !h.isCompleted).toList();

    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Ödev ve Görev Takibi', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHomeworkScreen()));
        },
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Ödev'),
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['Tümü', 'Devam Edenler', 'Tamamlananlar'].map((f) {
                final selected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: ThemeColors.primary.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: selected ? ThemeColors.primary : ThemeColors.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return _buildTaskCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(HomeworkItem item) {
    final bool isUrgent = item.priority == 'urgent';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: item.isCompleted ? Colors.green : (isUrgent ? ThemeColors.error : ThemeColors.secondary), width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isUrgent ? ThemeColors.errorContainer : ThemeColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(item.deadline, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isUrgent ? ThemeColors.onErrorContainer : ThemeColors.onSurfaceVariant)),
              ),
              Checkbox(
                value: item.isCompleted,
                activeColor: Colors.green,
                onChanged: (val) {
                  setState(() {
                    item.isCompleted = val ?? false;
                  });
                },
              ),
            ],
          ),
          Text(item.subject.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isUrgent ? ThemeColors.error : ThemeColors.secondary)),
          const SizedBox(height: 2),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ThemeColors.onSurface,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(item.detail, style: const TextStyle(fontSize: 12, color: ThemeColors.onSurfaceVariant)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.isCompleted ? 1.0 : (item.progress / 100),
                    minHeight: 6,
                    backgroundColor: ThemeColors.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(item.isCompleted ? Colors.green : (isUrgent ? ThemeColors.error : ThemeColors.secondary)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.isCompleted ? '%100' : '%' + item.progress.toString(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'spaced_repetition_screen.dart';
import 'add_homework_screen.dart';
import 'focus_timer_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<SpacedRepetitionItem> _todayRepetitions = [
    SpacedRepetitionItem(
      id: 'rep-1',
      subject: 'Matematik',
      topic: 'Türev ve İntegrale Giriş',
      description: 'Hızlı özet testi ve teğet denklemleri pekiştirmesi hazır.',
      phase: '1. Gün Tekrarı (Dün İşlendi)',
      duration: '15 dk',
      memoryScore: 85,
    ),
    SpacedRepetitionItem(
      id: 'rep-2',
      subject: 'Biyoloji',
      topic: 'Hücresel Solunum & ATP',
      description: 'Glikoliz ve Krebs döngüsü için 12 kartlık kavram testi.',
      phase: '7. Gün Tekrarı',
      duration: 'Flashcard',
      memoryScore: 70,
    ),
    SpacedRepetitionItem(
      id: 'rep-3',
      subject: 'Fizik',
      topic: 'Elektrik ve Manyetizma',
      description: 'Sağ el kuralı ve manyetik akı formüllerini gözden geçir.',
      phase: '14. Gün Tekrarı',
      duration: 'Not İncelemesi',
      memoryScore: 60,
    ),
    SpacedRepetitionItem(
      id: 'rep-4',
      subject: 'Türk Dili ve Edebiyatı',
      topic: 'Tanzimat Dönemi Yazarları & Eserleri',
      description: '1. ve 2. Dönem temsilcileri kilit eşleştirmeleri.',
      phase: '30. Gün Tekrarı (Aylık)',
      duration: 'Karma Soru',
      memoryScore: 50,
    ),
  ];

  final List<HomeworkItem> _upcomingHomeworks = [
    HomeworkItem(
      id: 'hw-1',
      title: 'Laboratuvar Raporu: Asit-Baz Titrasyonu',
      subject: 'Kimya',
      deadline: 'Yarın 17:00 (Son 22 Saat)',
      detail: 'Grafikler ve hata analizi bölümü eksik.',
      progress: 70,
      priority: 'urgent',
    ),
    HomeworkItem(
      id: 'hw-2',
      title: '50 Soru: Çemberde Açılar ve Teğetler',
      subject: 'Geometri',
      deadline: 'Cuma 23:59 (3 Gün Kaldı)',
      detail: '20 / 50 soru tamamlandı.',
      progress: 40,
      priority: 'normal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.menu_book_rounded, color: ThemeColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DİJİTAL DERS AJANDAM',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ThemeColors.primary, letterSpacing: 1.1),
                ),
                const Text(
                  'Bugün',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ThemeColors.onSurface),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Stack(
              children: [
                Icon(Icons.notifications_none_rounded, color: ThemeColors.onSurfaceVariant),
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(radius: 4, backgroundColor: ThemeColors.tertiary),
                )
              ],
            ),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 4),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: ThemeColors.surfaceContainerHighest,
              child: Icon(Icons.person, color: ThemeColors.primary, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: ThemeColors.primary.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('Günaydın, Selin! ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
                            Text('👋', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 13, color: ThemeColors.onSurfaceVariant),
                            children: [
                              TextSpan(text: 'Bugün zihnin taze: '),
                              TextSpan(text: '4 kritik tekrarın', style: TextStyle(color: ThemeColors.primary, fontWeight: FontWeight.bold)),
                              TextSpan(text: ' ve '),
                              TextSpan(text: '2 ödev teslimin', style: TextStyle(color: ThemeColors.tertiaryContainer, fontWeight: FontWeight.bold)),
                              TextSpan(text: ' var.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusTimerScreen()));
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: ThemeColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(21),
                      ),
                      child: const Icon(Icons.self_improvement, color: ThemeColors.primary, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Streak & Goal Progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 22),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mevcut Seri', style: TextStyle(fontSize: 10, color: ThemeColors.onSurfaceVariant)),
                            Text('12 Gün 🔥', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Günlük Hedef', style: TextStyle(fontSize: 10, color: ThemeColors.onSurfaceVariant)),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: '2s 40dk ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeColors.primary)),
                            TextSpan(text: '/ 4s', style: TextStyle(fontSize: 11, color: ThemeColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircularProgressIndicator(
                          value: 0.65,
                          backgroundColor: ThemeColors.surfaceContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.primary),
                          strokeWidth: 4,
                        ),
                        const Text('%65', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Spaced Repetition Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology_alt, color: ThemeColors.primary, size: 20),
                    SizedBox(width: 6),
                    Text('Bugünün Aktif Hatırlatmaları', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ThemeColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Ebbinghaus', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ThemeColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _todayRepetitions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _todayRepetitions[index];
                return _buildRepetitionCard(item);
              },
            ),

            const SizedBox(height: 20),

            // Homework Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.assignment_late_outlined, color: ThemeColors.tertiaryContainer, size: 20),
                    SizedBox(width: 6),
                    Text('Yaklaşan Ödev & Teslimler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    if (widget.onNavigateTab != null) widget.onNavigateTab!(2);
                  },
                  child: const Text('Tümünü Gör (2)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _upcomingHomeworks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final hw = _upcomingHomeworks[index];
                return _buildHomeworkCard(hw);
              },
            ),

            const SizedBox(height: 24),

            // Quick Actions Dock
            const Text('HIZLI EYLEMLER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant, letterSpacing: 1.0)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionBtn(
                    icon: Icons.add_circle_outline,
                    color: ThemeColors.primary,
                    label: 'Yeni Tekrar Ekle',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SpacedRepetitionScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionBtn(
                    icon: Icons.note_add_outlined,
                    color: ThemeColors.secondary,
                    label: 'Yeni Ödev Ekle',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHomeworkScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickActionBtn(
                    icon: Icons.timer,
                    color: Colors.white,
                    bgColor: ThemeColors.primaryContainer,
                    label: 'Çalışmaya Başla',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusTimerScreen()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRepetitionCard(SpacedRepetitionItem item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isCompleted ? ThemeColors.surfaceContainerLow : ThemeColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: item.isCompleted ? Border.all(color: Colors.green.shade200) : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ThemeColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(item.phase, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ThemeColors.primary)),
              ),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 13, color: ThemeColors.onSurfaceVariant),
                  const SizedBox(width: 3),
                  Text(item.duration, style: const TextStyle(fontSize: 11, color: ThemeColors.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.subject.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ThemeColors.secondary, letterSpacing: 0.8)),
          Text(item.topic, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
          const SizedBox(height: 4),
          Text(item.description, style: const TextStyle(fontSize: 12, color: ThemeColors.onSurfaceVariant)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt, size: 16, color: ThemeColors.primary),
                  const SizedBox(width: 4),
                  Text('Bellek Tazeliği: %' + item.memoryScore.toString(), style: const TextStyle(fontSize: 11, color: ThemeColors.onSurfaceVariant)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    item.isCompleted = !item.isCompleted;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.isCompleted ? Colors.green : ThemeColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                icon: Icon(item.isCompleted ? Icons.check_circle : Icons.play_arrow, size: 16),
                label: Text(item.isCompleted ? 'Tamamlandı' : 'Tekrarı Başlat', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHomeworkCard(HomeworkItem hw) {
    final bool isUrgent = hw.priority == 'urgent';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: isUrgent ? ThemeColors.error : ThemeColors.secondary, width: 4)),
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
                child: Text(hw.deadline, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isUrgent ? ThemeColors.onErrorContainer : ThemeColors.onSurfaceVariant)),
              ),
              const Icon(Icons.notifications_active_outlined, size: 16, color: ThemeColors.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(hw.subject.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isUrgent ? ThemeColors.error : ThemeColors.secondary)),
          Text(hw.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
          const SizedBox(height: 2),
          Text(hw.detail, style: const TextStyle(fontSize: 11, color: ThemeColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: hw.progress / 100,
                    minHeight: 6,
                    backgroundColor: ThemeColors.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(isUrgent ? ThemeColors.error : ThemeColors.secondary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('%' + hw.progress.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn({
    required IconData icon,
    required Color color,
    Color? bgColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor ?? ThemeColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: bgColor != null ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: bgColor != null ? Colors.white : ThemeColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

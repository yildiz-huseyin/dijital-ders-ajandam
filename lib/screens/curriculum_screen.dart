import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'exam_entry_screen.dart';
import 'written_exam_screen.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Matematik & Geometri',
      'icon': Icons.calculate,
      'progress': 0.72,
      'color': ThemeColors.primary,
      'completedTopics': 18,
      'totalTopics': 25,
      'topics': [
        {'title': 'Temel Kavramlar & Sayılar', 'done': true},
        {'title': 'Fonksiyonlar & Polinomlar', 'done': true},
        {'title': 'Trigonometri', 'done': true},
        {'title': 'Türev ve İntegral', 'done': false},
        {'title': 'Çemberde Açılar & Analitik', 'done': false},
      ]
    },
    {
      'name': 'Fizik',
      'icon': Icons.offline_bolt,
      'progress': 0.60,
      'color': Colors.blue,
      'completedTopics': 12,
      'totalTopics': 20,
      'topics': [
        {'title': 'Vektörler ve Bağıl Hareket', 'done': true},
        {'title': 'Newton Hareket Yasaları', 'done': true},
        {'title': 'Elektrik ve Manyetizma', 'done': false},
        {'title': 'Dalga Mekaniği & Optik', 'done': false},
      ]
    },
    {
      'name': 'Kimya',
      'icon': Icons.science,
      'progress': 0.85,
      'color': Colors.teal,
      'completedTopics': 17,
      'totalTopics': 20,
      'topics': [
        {'title': 'Kimyasal Türler Arası Etkileşimler', 'done': true},
        {'title': 'Mol Kavramı ve Hesaplamalar', 'done': true},
        {'title': 'Sıvı Çözeltiler ve Koligatif', 'done': true},
        {'title': 'Asitler, Bazlar ve Tuzlar', 'done': false},
      ]
    },
    {
      'name': 'Biyoloji',
      'icon': Icons.eco,
      'progress': 0.50,
      'color': Colors.green,
      'completedTopics': 10,
      'totalTopics': 20,
      'topics': [
        {'title': 'Hücre Yapısı ve Organeller', 'done': true},
        {'title': 'Hücresel Solunum & Fotosentez', 'done': true},
        {'title': 'Kalıtım ve Genetik', 'done': false},
        {'title': 'İnsan Fizyolojisi & Sistemler', 'done': false},
      ]
    },
    {
      'name': 'Türkçe & Edebiyat',
      'icon': Icons.auto_stories,
      'progress': 0.78,
      'color': ThemeColors.tertiaryContainer,
      'completedTopics': 15,
      'totalTopics': 19,
      'topics': [
        {'title': 'Sözcükte ve Cümlede Anlam', 'done': true},
        {'title': 'Paragrafta Anlam ve Yapı', 'done': true},
        {'title': 'Tanzimat & Servet-i Fünun', 'done': false},
        {'title': 'Cumhuriyet Dönemi Edebiyatı', 'done': false},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Ders ve Konu Yönetimi', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_chart, color: ThemeColors.primary),
            tooltip: 'Deneme Girişi',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamEntryScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.note_add, color: ThemeColors.secondary),
            tooltip: 'Yazılı Sınavı',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WrittenExamScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Progress Overview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Genel Müfredat Tamamlanma', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ThemeColors.onSurface)),
                      const Text('%69', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ThemeColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const LinearProgressIndicator(
                      value: 0.69,
                      minHeight: 8,
                      backgroundColor: ThemeColors.surfaceContainer,
                      valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('72 / 104 Konu Tamamlandı', style: TextStyle(fontSize: 11, color: ThemeColors.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('DERS LİSTESİ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant, letterSpacing: 1.0)),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sub = _subjects[index];
                return _buildSubjectExpansionCard(sub);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectExpansionCard(Map<String, dynamic> sub) {
    final double prog = sub['progress'] as double;
    final int percent = (prog * 100).round();
    final List topics = sub['topics'] as List;

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: sub['color'] as Color, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: (sub['color'] as Color).withOpacity(0.12),
          child: Icon(sub['icon'] as IconData, color: sub['color'] as Color),
        ),
        title: Text(sub['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: prog,
                  minHeight: 5,
                  backgroundColor: ThemeColors.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(sub['color'] as Color),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('%' + percent.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        children: topics.map((t) {
          final isDone = t['done'] as bool;
          return ListTile(
            dense: true,
            leading: Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : ThemeColors.outline,
              size: 20,
            ),
            title: Text(
              t['title'],
              style: TextStyle(
                fontSize: 13,
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? ThemeColors.onSurfaceVariant : ThemeColors.onSurface,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, size: 16),
              onPressed: () {},
            ),
          );
        }).toList(),
      ),
    );
  }
}

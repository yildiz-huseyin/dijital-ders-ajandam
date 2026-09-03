import 'package:flutter/material.dart';
import '../models/app_models.dart';

class SpacedRepetitionScreen extends StatefulWidget {
  const SpacedRepetitionScreen({super.key});

  @override
  State<SpacedRepetitionScreen> createState() => _SpacedRepetitionScreenState();
}

class _SpacedRepetitionScreenState extends State<SpacedRepetitionScreen> {
  final _topicController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedSubject = 'Matematik';
  int _selectedInterval = 1; // 1, 3, 7, 14, 30 days

  final List<String> _subjects = [
    'Matematik',
    'Geometri',
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Türkçe & Edebiyat',
    'Tarih',
    'Coğrafya',
    'Felsefe & Din'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.surface,
      appBar: AppBar(
        backgroundColor: ThemeColors.surface,
        elevation: 0,
        title: const Text('Konu & Aktif Tekrar Ekle', style: TextStyle(color: ThemeColors.onSurface, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanatory Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ThemeColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ThemeColors.primary.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.psychology, color: ThemeColors.primary, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ebbinghaus Unutma Eğrisi: Eklediğiniz konu 1, 7, 14 ve 30. günlerde otomatik olarak Bugün paneline hatırlatma olarak düşer.',
                      style: TextStyle(fontSize: 12, color: ThemeColors.onSurface, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ders Seçimi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSubject = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      labelText: 'Konu Başlığı',
                      hintText: 'Örn: Asitler ve Bazlar',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bookmark_border, color: ThemeColors.primary),
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Kilit Formüller & Hatırlatma Notları',
                      hintText: 'Formüller, istisnalar veya önemli püf noktalar...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('İlk Tekrar Zamanı', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeColors.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [1, 3, 7, 14, 30].map((days) {
                      final selected = _selectedInterval == days;
                      return ChoiceChip(
                        label: Text('$days. Gün'),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedInterval = days),
                        selectedColor: ThemeColors.primary.withOpacity(0.15),
                        labelStyle: TextStyle(
                          color: selected ? ThemeColors.primary : ThemeColors.onSurfaceVariant,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Konu hafıza döngüsüne eklendi! Zamanı geldiğinde hatırlatılacak.'),
                      backgroundColor: Colors.indigo,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save_outlined),
                label: const Text('Aktif Tekrar Döngüsüne Ekle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
